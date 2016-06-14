//
//  EditorViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 10/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class EditorViewController: UITableViewController, PhotoHelperDelegate, UITextViewDelegate {
	
	@IBOutlet weak var pictureView: UIImageView!
	@IBOutlet weak var firstNameLabel: UITextField!
	@IBOutlet weak var lastNameLabel: UITextField!
	@IBOutlet weak var address1Label: UITextField!
	@IBOutlet weak var address2Label: UITextField!
	@IBOutlet weak var zipCodeLabel: UITextField!
	@IBOutlet weak var cityLabel: UITextField!
	@IBOutlet weak var countryLabel: UITextField!
	@IBOutlet weak var emailLabel: UITextField!
	@IBOutlet weak var phoneLabel: UITextField!
	@IBOutlet weak var birthdayLabel: UILabel!
	@IBOutlet weak var skillsLabel: UILabel!
	@IBOutlet weak var professionsLabel: UILabel!
	@IBOutlet weak var trainingsLabel: UILabel!
	@IBOutlet weak var commentsView: UITextView!
	
	var helper: PhotoHelper!
	var datePickerView: UIViewController?
	let dateFormatter = NSDateFormatter()
	
	var photo: UIImage?
	var birthday: NSDate?
	var skills, professions, trainings: [Option]?
	
	var uuid: String!
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		defer {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		
		// picture
		if indexPath.section == 0 {
			helper.display()
		}
		
		let tag = tableView.cellForRowAtIndexPath(indexPath)!.tag
		switch tag {
		case 50: // birthday
			guard let pickerView = storyboard?.instantiateViewControllerWithIdentifier("DatePicker") else {
				print("Could not create picker view")
				return
			}
			let datePicker = pickerView as! DatePickerViewController
			datePicker.previousDate = birthday
			datePicker.datePickHandler = { (picker: UIDatePicker) in
				self.updateBirthday(picker.date)
			}
			tableView.scrollToNearestSelectedRowAtScrollPosition(.Middle, animated: true)
			presentViewController(pickerView, animated: true, completion: nil)
			
		case 51 ... 53: // skills/professions/trainings
			guard let controller = storyboard?.instantiateViewControllerWithIdentifier("OptionSelector") else {
				print("Could not create option selector view")
				return
			}
			var options: Options
			var handler: ([Option] -> Void)
			switch tag {
			case 51: // skills
				options = Skills.sharedInstance
				handler = { (selected) in
					self.skillsLabel.text = "\(selected.count) selected"
				}
			case 52: // professions
				options = Professions.sharedInstance
				handler = { (selected) in
					self.professionsLabel.text = "\(selected.count) selected"
				}
			default: // trainings
				options = Trainings.sharedInstance
				handler = { (selected) in
					self.trainingsLabel.text = "\(selected.count) selected"
				}
			}
			let selector = controller as! OptionSelectViewController
			selector.options = options
			selector.completionHandler = handler
			navigationController?.pushViewController(controller, animated: true)
			
		default:
			break
		}
	}
	
	func updateBirthday(date: NSDate) {
		birthday = date
		birthdayLabel.text = dateFormatter.stringFromDate(date)
	}
	
	func updateImage() {
		if let image = photo {
			pictureView.image = image
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		helper = PhotoHelper(delegate: self)
		dateFormatter.dateFormat = "dd.MM.yyyy"
		
		let defaults = NSUserDefaults.standardUserDefaults()
		if let id = defaults.stringForKey("UUID") {
			uuid = id
		} else {
			uuid = NSUUID().UUIDString
			defaults.setObject(uuid, forKey: "UUID")
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func submitPressed(button: UIButton) {
		print("Submitting!")
		submitApplication()
	}
	
	func submitApplication() -> Bool {
		do {
			let firstName = try collectTextFromField(firstNameLabel)
			let lastName = try collectTextFromField(lastNameLabel)
			let address1 = try collectTextFromField(address1Label)
			let zipCode = try collectTextFromField(zipCodeLabel)
			let city = try collectTextFromField(cityLabel)
			let country = try collectTextFromField(countryLabel)
			let email = try collectTextFromField(emailLabel)
			let phone = try collectTextFromField(phoneLabel)
			guard let bday = birthday else {
				throw Errors.MissingText(labelName: "Birthday")
			}
			let date: String = dateFormatter.stringFromDate(bday)
			guard let pic = photo else {
				throw Errors.MissingText(labelName: "Picture")
			}
			let address2 = address2Label.text
			let comments = commentsView.text
			
			let person: [String: AnyObject] = [
				"guid": uuid,
				"first_name": firstName,
				"last_name": lastName,
				"street_and_nr": address1,
				"address_line_2": address2 ?? "",
				"plz": zipCode,
				"place": city,
				"land": country,
				"email": email,
				"mobile": phone,
				"birthday_date": date,
				"comment": comments == "tap to edit" ? "" : comments
			]
			
			var professions: [AnyObject] = []
			for profession in Professions.sharedInstance.selected {
				professions.append([
					"profession_id": profession.ID,
					"other_profession": "",
					"training_id": 0, // TODO allow only one training per profession, and pick it here
					"other_training": "",
					"experience_type": 1
					])
			}
			
			var skills: [AnyObject] = []
			for skill in Skills.sharedInstance.selected {
				skills.append([
					"skill_id": skill.ID,
					"value": "true"
					])
			}
			
			var availabilities: [AnyObject] = [ // TODO implement availability choosing
				[
					"start_date": "24.02.1955",
					"end_date": "05.10.2011"
				], [
					"start_date": "01.06.2016",
					"end_date": ""
				]
			]
			
			let json: [String: AnyObject] = [
				"Person": person,
				"ProfessionInfos": professions,
				"SkillInfos": skills,
				"Availabilities": availabilities
			]
			
			if let serialized = JSONHelper.sharedInstance.serialize(json) {
				
				let helper = SubmissionHelper.sharedInstance
				
				let data = UIImageJPEGRepresentation(pic, 1)
				helper.sendRequest(jsonData: serialized, imageNamed: "userPicture.jpg", imageData: data!, toURL: "https://api.jobbau.famoser.ch/1.0/submit")
				
			}
			
		} catch Errors.MissingText(let name) {
			print("Missing text in field \"\(name)\"!")
			showAlert("Missing Input", text: "You forgot to set your \(name)")
		} catch {
			print("There was another error submitting the application!")
			print(error)
		}
		return false
	}
	
	func collectTextFromField(field: UITextField) throws -> String {
		if let text = field.text {
			return text
		}
		let name = field.placeholder ?? "[field name]"
		throw Errors.MissingText(labelName: name)
	}
	
	func showAlert(title: String, text: String) {
		let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)
		presentViewController(alert, animated: true) {
			UIView.animateWithDuration(1) {
				alert.dismissViewControllerAnimated(true, completion: nil)
			}
		}
	}
	
	// comment text view delegate methods
	
	func textViewDidBeginEditing(textView: UITextView) {
		if textView.tag == 0 {
			textView.text = ""
			textView.tag = 1
		}
	}
	
	// photo helper delegate methods
	
	func photoSelected(picture: UIImage) {
		photo = picture
		updateImage()
	}
	
	func viewController() -> UIViewController {
		return self
	}
}

enum Errors: ErrorType {
	case MissingText(labelName: String)
}