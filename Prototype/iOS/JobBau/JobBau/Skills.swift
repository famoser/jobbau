//
//  Skills.swift
//  JobBau
//
//  Created by Julian Dunskus on 12/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import Foundation

class Skills: Options {
	
	private static let shared = Skills()
	override class var sharedInstance: Options {
		return shared
	}
	
	override var jsonName: String {
		return "skills"
	}
}