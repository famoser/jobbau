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
		
		zipCodeField.inputAccessoryView = UIToolbar.doneToolbar(self, action: #selector(zipCodeDone))
		phoneField.inputAccessoryView = UIToolbar.doneToolbar(self, action: #selector(phoneNumberDone))
		
		birthdayField.inputView = UIDatePicker.picker(self, action: #selector(birthdayPicked))
		birthdayField.inputAccessoryView = UIToolbar.doneToolbar(self, action: #selector(birthdayDone))
		birthdayField.valueForKey("textInputTraits")?.setValue(UIColor.clearColor(), forKey: "insertionPointColor")
		
		photoHelper = PhotoHelper(delegate: self)
		
		let defaults = NSUserDefaults.standardUserDefaults()
		if let id = defaults.stringForKey("UUID") {
			uuid = id
		} else {
			uuid = NSUUID().UUIDString
			defaults.setObject(uuid, forKey: "UUID")
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
			
			var professions: [AnyObject] = []
			for profession in Professions.sharedInstance.selected {
				professions.append([
					"profession_id": profession.ID,
					"other_profession": profession.ID == -1 ? "true" : "",
					"training_id": profession.selectedTraining?.name ?? "",
					"other_training": profession.selectedTraining?.name == nil ? "true" : "",
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
						self.showAlert("Submission Successful", text: "Thank you!", forDuration: 3)
						loader.dismissViewControllerAnimated(true, completion: nil)
					}) {
						self.showAlert("Submission Failed", text: "Please try again later or contact support.", forDuration: 5)
						loader.dismissViewControllerAnimated(true, completion: nil)
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
		birthdayField.text = picker.date.toString()
	}
	
	func birthdayDone() {
		textFieldShouldReturn(birthdayField)
	}
	
	// text field delegate methods
	
	func zipCodeDone() {
		textFieldShouldReturn(zipCodeField)
	}
	
	func phoneNumberDone() {
		textFieldShouldReturn(phoneField)
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if let index = textFields.indexOf(textField) {
			if index < textFields.count - 1 {
				textFields[index + 1].becomeFirstResponder()
			}
		}
		
		return false
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

extension UIViewController {
	func showAlert(title: String, text: String?, forDuration duration: NSTimeInterval) {
		let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)
		presentViewController(alert, animated: true) {
			UIView.animateWithDuration(duration, animations: {
				alert.view.alpha = 0.9999999 // dummy animation for an easy wait
			}) { (success) in
				alert.dismissViewControllerAnimated(true, completion: nil)
			}
		}
	}
}

extension NSDate {
	func toString() -> String {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy"
		
		return dateFormatter.stringFromDate(self)
	}
	
	func toISO8601() -> String {
		let dateFormatter = NSDateFormatter()
		let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
		dateFormatter.locale = enUSPosixLocale
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
		
		return dateFormatter.stringFromDate(self)
	}
}

extension UIToolbar {
	static func doneToolbar(controller: UIViewController, action: Selector) -> UIToolbar {
		let toolbar = UIToolbar()
		toolbar.autoresizingMask = .FlexibleHeight
		toolbar.items = [
			UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
			UIBarButtonItem(barButtonSystemItem: .Done, target: controller, action: action)
		]
		return toolbar
	}
}

extension UIDatePicker {
	static func picker(controller: UIViewController, action: Selector) -> UIDatePicker {
		let picker = UIDatePicker()
		picker.datePickerMode = .Date
		picker.addTarget(controller, action: action, forControlEvents: .ValueChanged)
		return picker
	}
}
