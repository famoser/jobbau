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
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func submitPressed(button: UIButton) {
		print("Submitting!")
	}
	
	func submitApplication() -> Bool {
		do {
			let firstName = try collectTextFromField(firstNameLabel)
			let lastName = try collectTextFromField(lastNameLabel)
			let zipCode = try collectTextFromField(zipCodeLabel)
			let city = try collectTextFromField(cityLabel)
			let country = try collectTextFromField(countryLabel)
			let email = try collectTextFromField(emailLabel)
			let phone = try collectTextFromField(phoneLabel)
			guard let bday = birthday else {
				throw Errors.MissingText(labelName: "Birthday")
			}
			let comments = commentsView.text
			let skills = Skills.sharedInstance.selected
			let professions = Professions.sharedInstance.selected
			let trainings = Trainings.sharedInstance.selected
			
			// TODO submit
			
			return true
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