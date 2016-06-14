//
//  JSONHelper.swift
//  JobBau
//
//  Created by Julian Dunskus on 12/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import Foundation

class JSONHelper
{
	static let sharedInstance = JSONHelper()
	
	func loadJSON(fileName: String) -> [[String: AnyObject]]? {
		if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json"),
			let jsonData = NSData(contentsOfFile: path) {
			do {
				guard let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as? Array<[String: AnyObject]> else {
					print("Could not serialize \(fileName).json")
					return nil
				}
				return jsonDict
			} catch {
				print("Error reading \(fileName).json:")
				print(error)
			}
		} else {
			print("Could not read \(fileName).json")
		}
		return nil
	}
	
	func serialize(json: [String: AnyObject]) -> NSData? {
		do {
			return try NSJSONSerialization.dataWithJSONObject(json, options: [])
		} catch {
			print("Could not serialize JSON!")
			print(error)
		}
		return nil
	}
}