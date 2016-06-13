//
//  Trainings.swift
//  JobBau
//
//  Created by Julian Dunskus on 12/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import Foundation

class Trainings: Options {
	
	private static let shared = Trainings()
	override class var sharedInstance: Options {
		return shared
	}
	
	override var jsonName: String {
		return "trainings"
	}
	
	override func optionFromDict(dict: [String: AnyObject]) -> Option {
		let id = dict["id"] as! Int
		let p_id = dict["profession_id"] as! Int
		let name = dict["name"] as! String
		return Training(ID: id, professionID: p_id, name: name)
	}
	
	override func availableOptions() -> [Option] { // only allow trainings for selected professions
		
		var allowed: [Training] = []
		
		let professions = Professions.sharedInstance.selected
		
		for option in options {
			let training = option as! Training
			for profession in professions {
				if training.professionID == profession.ID {
					allowed.append(training)
				}
			}
		}
		
		return allowed
	}
}

class Training: Option {
	
	var professionID: Int
	
	init(ID id: Int, professionID pID: Int, name n: String) {
		professionID = pID
		super.init(ID: id, name: n)
	}
}