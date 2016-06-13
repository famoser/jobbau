//
//  Options.swift
//  JobBau
//
//  Created by Julian Dunskus on 13/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import Foundation

class Options {
	
	private static let shared = Options()
	class var sharedInstance: Options {
		return shared
	}
	
	var options: [Option] = []
	var selected: [Option] = []
	
	var jsonName: String {
		return "options"
	}
	
	init() {
		if let json = JSONHelper.sharedInstance.loadJSON(jsonName) {
			for dict in json {
				options.append(optionFromDict(dict))
			}
		}
		options.sortInPlace() { $0.name.lowercaseString < $1.name.lowercaseString }
	}
	
	func optionFromDict(dict: [String: AnyObject]) -> Option {
		let id = dict["id"] as! Int
		let name = dict["name"] as! String
		return Option(ID: id, name: name)
	}
	
	func availableOptions() -> [Option] {
		return options
	}
}

class Option: Equatable {
	
	var ID: Int
	var name: String
	
	init(ID id: Int, name n: String) {
		ID = id
		name = n
	}
}

func ==(left: Option, right: Option) -> Bool {
	return left.ID == right.ID
}