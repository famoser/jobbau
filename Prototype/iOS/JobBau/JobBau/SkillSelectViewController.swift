//
//  OptionSelectViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 13/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class SkillSelectViewController: UITableViewController {
	
	var skills: Skills!
	
	var completionHandler: (() -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		skills = Skills.sharedInstance
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return skills.skills.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Option")!
		let skill = skills.skills[indexPath.row]
		if skills.selected.contains(skill) {
			cell.accessoryType = .Checkmark
		} else {
			cell.accessoryType = .None
		}
		let label = cell.viewWithTag(10) as! UILabel
		label.text = skill.name
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		defer {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		let skill = skills.skills[indexPath.row]
		let possibleIndex = skills.selected.indexOf(skill)
		if let index = possibleIndex {
			cell?.accessoryType = .None
			skills.selected.removeAtIndex(index)
		} else {
			cell?.accessoryType = .Checkmark
			skills.selected.append(skill)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		completionHandler?()
	}
}
