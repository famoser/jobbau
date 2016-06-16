//
//  Trainings.swift
//  JobBau
//
//  Created by Julian Dunskus on 12/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import Foundation

class Trainings {
	
	private static let sharedInstance = Trainings()
	
	var trainings: [Int: [Training]] = [:]
	
	var jsonName: String {
		return "trainings"
	}
	
	init() {
		if let json = JSONHelper.sharedInstance.loadJSON(jsonName) {
			for dict in json {
				let new = optionFromDict(dict)
				let id = new.professionID
				if trainings[id] != nil {
					trainings[id]?.append(new)
				} else {
					trainings[id] = [new]
				}
			}
		}
	}
	
	func optionFromDict(dict: [String: AnyObject]) -> Training {
		let id = dict["id"] as! Int
		let p_id = dict["profession_id"] as! Int
		let name = dict["name"] as! String
		return Training(ID: id, professionID: p_id, name: name)
	}
}

class Training {
	
	var ID: Int
	var professionID: Int
	var name: String
	
	init(ID id: Int, professionID pID: Int, name n: String) {
		ID = id
		professionID = pID
		name = n
	}
}
