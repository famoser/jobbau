//
//  AvailabilitySelectViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 15/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class AvailabilitySelectViewController: UITableViewController {
	
	@IBOutlet weak var addButton: UIBarButtonItem!
	var completionHandler: (() -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return EditorViewController.availabilities.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Availability")!
		let startLabel = cell.viewWithTag(10) as! UILabel
		let endLabel = cell.viewWithTag(11) as! UILabel
		let availb = EditorViewController.availabilities[indexPath.row]
		startLabel.text = "Start: \(availb.0.toString())"
		endLabel.text = "End: \(availb.1.toString())"
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		defer {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		
		let editor = storyboard?.instantiateViewControllerWithIdentifier("AvailabilityEditor") as! AvailabilityEditViewController
		let availb = EditorViewController.availabilities[indexPath.row]
		editor.startDate = availb.0
		editor.endDate = availb.1
		editor.completionHandler = { (start, end) in
			EditorViewController.availabilities[indexPath.row] = (start!, end!)
			self.tableView.reloadData()
		}
		editor.removalHandler = {
			EditorViewController.availabilities.removeAtIndex(indexPath.row)
			self.tableView.reloadData()
		}
		navigationController?.pushViewController(editor, animated: true)
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 79
	}
	
	@IBAction func addPressed(sender: UIBarButtonItem) {
		let adder = storyboard?.instantiateViewControllerWithIdentifier("AvailabilityEditor") as! AvailabilityEditViewController
		adder.completionHandler = { (start, end) in
			if let s = start, let e = end {
				EditorViewController.availabilities.append(s, e)
				self.tableView.reloadData()
			} else {
				self.showAlert("Missing Dates", text: "You didn't set start and end dates for your availability", forDuration: 3)
			}
		}
		navigationController?.pushViewController(adder, animated: true)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		completionHandler?()
	}
}
