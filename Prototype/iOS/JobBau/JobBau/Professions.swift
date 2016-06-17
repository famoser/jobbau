//
//  Professions.swift
//  JobBau
//
//  Created by Julian Dunskus on 12/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import Foundation

class Professions {
	
	static let sharedInstance = Professions()
	private var trainings: Trainings
	var professions: [Profession] = []
	var selected: [Profession] = []
	
	init() {
		trainings = Trainings()
		if let json = JSONHelper.sharedInstance.loadJSON("professions") {
			for dict in json {
				let prof = professionFromDict(dict)
				professions.append(prof)
				prof.trainings = trainings.trainings[prof.ID] ?? []
			}
		}
		professions.sortInPlace() { $0.name.lowercaseString < $1.name.lowercaseString }
		let other = Profession(ID: -1, name: "Other...")
		other.trainings = []
		professions.append(other)
	}
	
	func professionFromDict(dict: [String: AnyObject]) -> Profession {
		let id = dict["id"] as! Int
		let name = dict["name"] as! String
		return Profession(ID: id, name: name)
	}
}

class Profession: Equatable {
	
	var ID: Int
	var name: String
	var trainings: [Training] = []
	var selectedTraining: Training?
	var experienceType = 0
	
	init(ID id: Int, name n: String) {
		ID = id
		name = n
	}
}

func ==(left: Profession, right: Profession) -> Bool {
	return left.ID == right.ID
}
