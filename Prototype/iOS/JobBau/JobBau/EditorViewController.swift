//
//  EditorViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 10/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class EditorViewController: UITableViewController, PhotoHelperDelegate, UITextViewDelegate, UITextFieldDelegate {
	
	@IBOutlet weak var pictureView: UIImageView!
	@IBOutlet weak var firstNameField: UITextField!
	@IBOutlet weak var lastNameField: UITextField!
	@IBOutlet weak var address1Field: UITextField!
	@IBOutlet weak var address2Field: UITextField!
	@IBOutlet weak var zipCodeField: UITextField!
	@IBOutlet weak var cityField: UITextField!
	@IBOutlet weak var countryField: UITextField!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var phoneField: UITextField!
	@IBOutlet weak var skillsLabel: UILabel!
	@IBOutlet weak var professionsLabel: UILabel!
	@IBOutlet weak var availabilitiesLabel: UILabel!
	@IBOutlet weak var commentsView: UITextView!
	@IBOutlet weak var birthdayField: UITextField!
	
	var photoHelper: PhotoHelper!
	var textFields: [UITextField] = []
	let defaults = NSUserDefaults.standardUserDefaults()
	
	var photo: UIImage?
	var birthday: NSDate?
	static var availabilities: [(NSDate, NSDate)] = []
	
	var uuid: String!
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		defer {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		
		// picture
		if indexPath.section == 0 {
			photoHelper.display()
		}
		
		let tag = tableView.cellForRowAtIndexPath(indexPath)!.tag
		switch tag {
		case 51: // skills
			guard let controller = storyboard?.instantiateViewControllerWithIdentifier("SkillSelector") else {
				print("Could not create skill selector view")
				return
			}
			let selector = controller as! SkillSelectViewController
			selector.completionHandler = {
				self.skillsLabel.text = "\(Skills.sharedInstance.selected.count) selected"
			}
			navigationController?.pushViewController(controller, animated: true)
			
		case 52: // professions
			guard let controller = storyboard?.instantiateViewControllerWithIdentifier("ProfessionSelector") else {
				print("Could not create profession selector view")
				return
			}
			let selector = controller as! ProfessionSelectViewController
			selector.completionHandler = {
				self.professionsLabel.text = "\(Professions.sharedInstance.selected.count) selected"
			}
			navigationController?.pushViewController(controller, animated: true)
			
		case 53: // availabilities
			guard let controller = storyboard?.instantiateViewControllerWithIdentifier("AvailabilitySelector") else {
				print("Could not create availability selector view")
				return
			}
			let selector = controller as! AvailabilitySelectViewController
			selector.completionHandler = {
				self.availabilitiesLabel.text = "\(EditorViewController.availabilities.count) selected"
			}
			navigationController?.pushViewController(controller, animated: true)
			
		default:
			break
		}
	}
	
	func updateImage() {
		if let image = photo {
			pictureView.image = image
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		textFields = [
			firstNameField,
			lastNameField,
			address1Field,
			address2Field,
			zipCodeField,
			cityField,
			countryField,
			emailField,
			phoneField,
			birthdayField
		]
		
		zipCodeField.addToolbar()
		phoneField.addToolbar()
		
		birthdayField.makeDateField(dateChanged: (self, #selector(birthdayPicked)))
		
		photoHelper = PhotoHelper(delegate: self)
		
		loadFromDefaults()
	}
	
	func loadFromDefaults() {
		/* TODO use this later, atm we want a new one for every submission
		if let id = defaults.stringForKey("UUID") {
		uuid = id
		} else {
		uuid = NSUUID().UUIDString
		defaults.setObject(uuid, forKey: "UUID")
		}
		*/
		uuid = NSUUID().UUIDString
		
		for field in textFields {
			if field == birthdayField {
				continue
			}
			if let key = field.placeholder {
				field.text = defaults.stringForKey(key)
			}
		}
		if let text = defaults.stringForKey("Comments") {
			commentsView.text = text
		}
	}
	
	@IBAction func submitPressed(button: UIButton) {
		print("Submitting!")
		submitApplication()
	}
	
	func submitApplication() -> Bool {
		do {
			guard let pic = photo else {
				throw Errors.MissingText(labelName: "Picture")
			}
			let firstName = try collectTextFromField(firstNameField)
			let lastName = try collectTextFromField(lastNameField)
			let address1 = try collectTextFromField(address1Field)
			let zipCode = try collectTextFromField(zipCodeField)
			let city = try collectTextFromField(cityField)
			let country = try collectTextFromField(countryField)
			let email = try collectTextFromField(emailField)
			let phone = try collectTextFromField(phoneField)
			guard let bday = birthday else {
				throw Errors.MissingText(labelName: "Birthday")
			}
			let date: String = bday.toISO8601()
			let address2 = address2Field.text
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
			
			var professions: [[String: AnyObject]] = []
			for profession in Professions.sharedInstance.selected {
				professions.append([
					"profession_id": profession.ID,
					"other_profession": profession.name,
					"training_id": profession.selectedTraining?.ID ?? "",
					"other_training": profession.selectedTraining?.name ?? "",
					"experience_type": profession.experienceType
					])
			}
			
			var skills: [AnyObject] = []
			for skill in Skills.sharedInstance.selected {
				skills.append([
					"skill_id": skill.ID,
					"value": "true"
					])
			}
			
			var availbs: [AnyObject] = []
			for availb in EditorViewController.availabilities {
				availbs.append([
					"start_date": availb.0.toISO8601(),
					"end_date": availb.1.toISO8601()
					])
			}
			
			let json: [String: AnyObject] = [
				"Person": person,
				"ProfessionInfos": professions,
				"SkillInfos": skills,
				"Availabilities": availbs
			]
			
			if let serialized = JSONHelper.sharedInstance.serialize(json) {
				
				let helper = SubmissionHelper.sharedInstance
				
				let data = UIImageJPEGRepresentation(pic, 1)
				
				let confirmation = UIAlertController(title: "Submit?", message: "Are you sure you want to submit your application?", preferredStyle: .Alert)
				confirmation.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
				confirmation.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { (action) in
					let loader = UIAlertController(title: "Submitting…", message: nil, preferredStyle: .Alert)
					self.presentViewController(loader, animated: true, completion: nil)
					helper.sendRequest(jsonData: serialized, imageNamed: "userPicture.jpg", imageData: data!, toURL: "https://api.jobbau.famoser.ch/1.0/submit", success: {
						loader.dismissViewControllerAnimated(true, completion: nil)
						self.showAlert("Submission Successful", text: "Thank you!", forDuration: 2)
					}) {
						loader.dismissViewControllerAnimated(true, completion: nil)
						self.showAlert("Submission Failed", text: "Please try again later or contact support.", forDuration: 4)
					}
				}))
				presentViewController(confirmation, animated: true, completion: nil)
				
			}
			
		} catch Errors.MissingText(let name) {
			print("Missing text in field \"\(name)\"!")
			showAlert("Missing Input", text: "You forgot to set your \(name)", forDuration: 0.5)
		} catch {
			print("There was another error submitting the application!")
			print(error)
		}
		return false
	}
	
	func collectTextFromField(field: UITextField) throws -> String {
		if let text = field.text {
			if !text.isEmpty {
				return text
			}
		}
		let name = field.placeholder ?? "[field name]"
		throw Errors.MissingText(labelName: name)
	}
	
	// birthday picker delegate methods
	
	func birthdayPicked(picker: UIDatePicker) {
		birthday = picker.date
	}
	
	// text field delegate methods
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if let index = textFields.indexOf(textField) {
			if index < textFields.count - 1 {
				textFields[index + 1].becomeFirstResponder()
			}
		}
		
		return false
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		if textField == birthdayField { // don't store the birthday, since it's a date
			return
		}
		
		if let key = textField.placeholder, text = textField.text {
			defaults.setObject(text, forKey: key)
		}
	}
	
	// comment text view delegate methods
	
	func textViewDidBeginEditing(textView: UITextView) {
		if textView.tag == 0 {
			textView.text = ""
			textView.tag = 1
		}
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		defaults.setObject(textView.text, forKey: "Comments")
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
