//
//  DatePickerViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 13/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController
{
	@IBOutlet weak var datePicker: UIDatePicker!
	
	var datePickHandler: ((UIDatePicker) -> Void)?
	var previousDate: NSDate?
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		view.backgroundColor = UIColor.clearColor()
		if let date = previousDate {
			datePicker.date = date
		}
	}
	
	@IBAction func datePicked(picker: UIDatePicker) {
		datePickHandler?(picker)
	}
	
	@IBAction func donePressed(button: UIBarButtonItem?) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches {
			for subview in view.subviews {
				if CGRectContainsPoint(subview.frame, touch.locationInView(view)) {
					return
				}
			}
		}
		// if tapped outside the picker/toolbar, dismiss
		donePressed(nil)
	}
}