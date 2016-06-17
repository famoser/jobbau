//
//  Extensions.swift
//  JobBau
//
//  Created by Julian Dunskus on 17/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func showAlert(title: String, text: String? = nil, forDuration duration: NSTimeInterval) {
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
	
	static func doneToolbar(target: AnyObject, action: Selector) -> UIToolbar {
		let toolbar = UIToolbar()
		toolbar.autoresizingMask = .FlexibleHeight
		toolbar.items = [
			UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
			UIBarButtonItem(barButtonSystemItem: .Done, target: target, action: action)
		]
		return toolbar
	}
}

extension UIDatePicker {
	
	static func picker(pickHandler: (AnyObject, Selector), additionalHandler: (AnyObject, Selector)? = nil, initialDate date: NSDate? = nil) -> UIDatePicker {
		let picker = UIDatePicker()
		picker.datePickerMode = .Date
		picker.addTarget(pickHandler.0, action: pickHandler.1, forControlEvents: .ValueChanged)
		if let handler = additionalHandler {
			picker.addTarget(handler.0, action: handler.1, forControlEvents: .ValueChanged)
		}
		picker.date = date ?? NSDate()
		return picker
	}
}

extension UITextField {
	
	func addToolbar(donePressed: (AnyObject, Selector)) {
		inputAccessoryView = UIToolbar.doneToolbar(donePressed.0, action: donePressed.1)
	}
	
	func addToolbar() {
		inputAccessoryView = UIToolbar.doneToolbar(self, action: #selector(done))
	}
	
	func makeDateField(donePressed doneHandler: (AnyObject, Selector)? = nil, dateChanged: (AnyObject, Selector), initialDate date: NSDate? = nil, autoApplyDate: Bool = true) {
		addToolbar(doneHandler ?? (self, #selector(done)))
		inputView = UIDatePicker.picker(dateChanged, additionalHandler: autoApplyDate ? (self, #selector(updateDate)) : nil, initialDate: date)
		valueForKey("textInputTraits")?.setValue(UIColor.clearColor(), forKey: "insertionPointColor")
		text = date?.toString()
	}
	
	func updateDate(picker: UIDatePicker) {
		text = picker.date.toString()
	}
	
	func done() {
		delegate?.textFieldShouldReturn?(self) // pretend to return, so as to have the delegate resign first responder
	}
}
