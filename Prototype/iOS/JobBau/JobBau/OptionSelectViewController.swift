//
//  OptionSelectViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 13/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class OptionSelectViewController: UITableViewController {
	
	var options: Options!
	var optionList: [Option]!
	
	var completionHandler: ([Option] -> Void)?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		optionList = options.availableOptions()
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return optionList.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Option")!
		let option = optionList[indexPath.row]
		if options.selected.contains(option) {
			cell.accessoryType = .Checkmark
		} else {
			cell.accessoryType = .None
		}
		let label = cell.viewWithTag(10) as! UILabel
		label.text = option.name
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		defer {
			tableView.deselectRowAtIndexPath(indexPath, animated: true)
		}
		let cell = tableView.cellForRowAtIndexPath(indexPath)
		let option = optionList[indexPath.row]
		let possibleIndex = options.selected.indexOf(option)
		if let index = possibleIndex {
			cell?.accessoryType = .None
			options.selected.removeAtIndex(index)
		} else {
			cell?.accessoryType = .Checkmark
			options.selected.append(option)
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		completionHandler?(options.selected)
	}
}