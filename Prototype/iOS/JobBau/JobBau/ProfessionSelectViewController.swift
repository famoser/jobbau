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
		var profession = professions.professions[indexPath.row]
		let possibleIndex = professions.selected.indexOf(profession)
		let trainingChooser = {
			if let index = possibleIndex {
				cell?.accessoryType = .None
				self.professions.selected.removeAtIndex(index)
			} else {
				let experienceChooser = {
					let sheet = UIAlertController(title: "Experience", message: "How many years have you worked in the field?", preferredStyle: .ActionSheet)
					let types = Constants.experienceTypes
					for i in 0 ..< types.count {
						sheet.addAction(UIAlertAction(title: types[i], style: .Default, handler: { (action) in
							profession.experienceType = i
							cell?.accessoryType = .Checkmark
							self.professions.selected.append(profession)
						}))
					}
					sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
					self.presentViewController(sheet, animated: true, completion: nil)
				}
				
				let sheet = UIAlertController(title: "Choose a Training", message: nil, preferredStyle: .ActionSheet)
				for training in profession.trainings {
					sheet.addAction(UIAlertAction(title: training.name, style: .Default) { (action) in
						profession.selectedTraining = training
						experienceChooser()
						})
				}
				sheet.addAction(UIAlertAction(title: "Other...", style: .Default) { (action) in
					let alert = UIAlertController(title: "Training Name", message: "Enter the name of your training", preferredStyle: .Alert)
					alert.addTextFieldWithConfigurationHandler({ (textField) in
						textField.placeholder = "Training Name"
					})
					alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
					alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action) in
						if let text = alert.textFields?.first?.text {
							let training = Training(ID: -2, professionID: profession.ID, name: text)
							profession.trainings.append(training)
							profession.selectedTraining = training
							experienceChooser()
						} else {
							self.showAlert("No name set", text: "You didn't name your training.", forDuration: 2)
						}
					}))
					self.presentViewController(alert, animated: true, completion: nil)
					})
				sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
				self.presentViewController(sheet, animated: true, completion: nil)
			}
		}
		if profession.ID != -1 { // not other
			trainingChooser()
		} else {
			let alert = UIAlertController(title: "Profession Name", message: "Enter the name of your profession", preferredStyle: .Alert)
			alert.addTextFieldWithConfigurationHandler({ (textField) in
				textField.placeholder = "Profession Name"
			})
			alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
			alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: { (action) in
				if let text = alert.textFields?.first?.text {
					profession = Profession(ID: -2, name: text)
					let temp = self.professions.professions.removeLast()
					self.professions.professions.append(profession)
					self.professions.professions.append(temp)
					self.tableView.reloadData()
					trainingChooser()
				} else {
					self.showAlert("No name set", text: "You didn't name your profession.", forDuration: 2)
				}
			}))
			presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		completionHandler?()
	}
}
