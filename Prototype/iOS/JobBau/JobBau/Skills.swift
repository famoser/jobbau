//
//  Skills.swift
//  JobBau
//
//  Created by Julian Dunskus on 12/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import Foundation

class Skills {
	
	static let sharedInstance = Skills()
	var skills: [Skill] = []
	var selected: [Skill] = []
	
	init() {
		if let json = JSONHelper.sharedInstance.loadJSON("skills") {
			for dict in json {
				skills.append(skillFromDict(dict))
			}
		}
		skills.sortInPlace() { $0.name.lowercaseString < $1.name.lowercaseString }
	}
	
	func skillFromDict(dict: [String: AnyObject]) -> Skill {
		let id = dict["id"] as! Int
		let name = dict["name"] as! String
		return Skill(ID: id, name: name)
	}
}

class Skill: Equatable {
	
	var ID: Int
	var name: String
	
	init(ID id: Int, name n: String) {
		ID = id
		name = n
	}
}

func ==(left: Skill, right: Skill) -> Bool {
	return left.ID == right.ID
}
