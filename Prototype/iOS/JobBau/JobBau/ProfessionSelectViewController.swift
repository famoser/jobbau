//
//  ProfessionSelectViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 14/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class ProfessionSelectViewController: UITableViewController {
	
	var professions: Professions!
	
	var completionHandler: (() -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		professions = Professions.sharedInstance
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return professions.professions.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Option")!
		let profession = professions.professions[indexPath.row]
		if professions.selected.contains(profession) {
			cell.accessoryType = .Checkmark
		} else {
			cell.accessoryType = .None
		}
		let label = cell.viewWithTag(10) as! UILabel
		label.text = profession.name
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		defer {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		let profession = professions.professions[indexPath.row]
		let possibleIndex = professions.selected.indexOf(profession)
		if let index = possibleIndex {
			cell?.accessoryType = .None
			professions.selected.removeAtIndex(index)
		} else {
			let nextHandler = {
				let sheet = UIAlertController(title: "Experience", message: "How many years have you worked in the field?", preferredStyle: .ActionSheet)
				let types = Constants.experienceTypes
				for i in 0 ..< types.count {
					sheet.addAction(UIAlertAction(title: types[i], style: .Default, handler: { (action) in
						profession.experienceType = i
						cell?.accessoryType = .Checkmark
						self.professions.selected.append(profession)
					}))
				}
				self.presentViewController(sheet, animated: true, completion: nil)
			}
			
			let sheet = UIAlertController(title: "Choose a Training", message: nil, preferredStyle: .ActionSheet)
			for training in profession.trainings {
				sheet.addAction(UIAlertAction(title: training.name, style: .Default) { (action) in
					profession.selectedTraining = training
					nextHandler()
					})
			}
			sheet.addAction(UIAlertAction(title: "Other", style: .Default) { (action) in
				profession.selectedTraining = nil
				nextHandler()
				})
			sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
			presentViewController(sheet, animated: true, completion: nil)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		completionHandler?()
	}
}
