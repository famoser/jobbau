//
//  AvailabilityEditViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 15/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class AvailabilityEditViewController: UITableViewController {
	
	@IBOutlet weak var startDateField: UITextField!
	@IBOutlet weak var endDateField: UITextField!
	@IBOutlet weak var removeButton: UIButton!
	
	var startDatePicker: UIDatePicker!
	var endDatePicker: UIDatePicker!
	var startDate: NSDate?
	var endDate: NSDate?
	
	var completionHandler: ((NSDate?, NSDate?) -> Void)?
	var removalHandler: (() -> Void)?
	var canRemove = false
	var removed = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		startDatePicker = UIDatePicker.picker(self, action: #selector(startDatePicked))
		endDatePicker = UIDatePicker.picker(self, action: #selector(endDatePicked))
		if let date = startDate {
			startDatePicker.date = date
			startDateField.text = date.toString()
		}
		if let date = endDate {
			endDatePicker.date = date
			endDateField.text = date.toString()
		}
		
		startDateField.inputView = startDatePicker
		startDateField.inputAccessoryView = UIToolbar.doneToolbar(self, action: #selector(startDateDone))
		startDateField.valueForKey("textInputTraits")?.setValue(UIColor.clearColor(), forKey: "insertionPointColor")
		
		endDateField.inputView = endDatePicker
		endDateField.inputAccessoryView = UIToolbar.doneToolbar(self, action: #selector(endDateDone))
		endDateField.valueForKey("textInputTraits")?.setValue(UIColor.clearColor(), forKey: "insertionPointColor")
	}
	
	func movePicker(picker: UIDatePicker) {
		let frame = view.frame
		print(frame)
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 1 {
			return removalHandler == nil ? 0 : 1
		}
		return 2
	}
	
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 1 && removalHandler == nil {
			return 0
		}
		return 32
	}
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 1 && removalHandler == nil {
			return UIView(frame: CGRectZero)
		}
		return nil
	}
	
	@IBAction func remove(sender: UIButton) {
		removed = true
		removalHandler?()
		navigationController?.popViewControllerAnimated(true)
	}
	
	func startDateDone() {
		startDateField.resignFirstResponder()
	}
	
	func endDateDone() {
		endDateField.resignFirstResponder()
	}
	
	func startDatePicked(picker: UIDatePicker) {
		startDate = picker.date
		startDateField.text = "Start: \(startDate?.toString() ?? "not set")"
	}
	
	func endDatePicked(picker: UIDatePicker) {
		endDate = picker.date
		endDateField.text = "End: \(endDate?.toString() ?? "not set")"
	}
	
	override func viewWillDisappear(animated: Bool) {
		if !removed {
			completionHandler?(startDate, endDate)
		}
	}
	
}
