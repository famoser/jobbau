//
//  AvailabilityEditViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 15/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class AvailabilityEditViewController: UITableViewController {
	
	@IBOutlet weak var startDatePicker: UIDatePicker!
	@IBOutlet weak var endDatePicker: UIDatePicker!
	
	var startDate: NSDate?
	var endDate: NSDate?
	
	var completionHandler: ((NSDate?, NSDate?) -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let date = startDate {
			startDatePicker.date = date
		}
		if let date = endDate {
			endDatePicker.date = date
		}
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		if #available(iOS 10, *) {
			movePicker(startDatePicker)
			movePicker(endDatePicker)
		}
		view.setNeedsLayout()
	}
	
	func movePicker(picker: UIDatePicker) {
		let frame = view.frame
		print(frame)
		
	}
	
	@IBAction func startDatePicked(picker: UIDatePicker) {
		startDate = picker.date
	}
	
	@IBAction func endDatePicked(picker: UIDatePicker) {
		endDate = picker.date
	}
	
	override func viewWillDisappear(animated: Bool) {
		completionHandler?(startDate, endDate)
	}
	
}
