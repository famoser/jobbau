//
//  JobBauTests.swift
//  JobBauTests
//
//  Created by Julian Dunskus on 10/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import XCTest
@testable import JobBau

class JobBauTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock {
			// Put the code you want to measure the time of here.
		}
	}
	
	func testSubmission() {
		
		let person: [String: AnyObject] = [
			"guid": NSUUID().UUIDString,
			"first_name": "Julian",
			"last_name": "Tester",
			"street_and_nr": "Teststrasse 1",
			"address_line_2": "",
			"plz": 1234,
			"place": "Zurich",
			"land": "Switzerland",
			"email": "julian.dunskus@gmail.com",
			"mobile": "012 345 67 89",
			"birthday_date": NSDate().description,
			"comment": "testing"
		]
		
		var professions: [AnyObject] = []
		for profession in Professions.sharedInstance.selected {
			professions.append([
				"profession_id": profession.ID,
				"other_profession": "",
				"training_id": 0, // TODO allow only one training per profession, and pick it here
				"other_training": "",
				"experience_type": 1
				])
		}
		
		var skills: [AnyObject] = []
		for skill in Skills.sharedInstance.selected {
			skills.append([
				"skill_id": skill.ID,
				"value": "true"
				])
		}
		
		let availabilities: [AnyObject] = [ // TODO implement availability choosing
			[
				"start_date": "24.02.1955",
				"end_date": "05.10.2011"
			], [
				"start_date": "01.06.2016",
				"end_date": ""
			]
		]
		
		let json: [String: AnyObject] = [
			"Person": person,
			"ProfessionInfos": professions,
			"SkillInfos": skills,
			"Availabilities": availabilities
		]
		
		let serialized = JSONHelper.sharedInstance.serialize(json)!
		let helper = SubmissionHelper.sharedInstance
		if let image = UIImage(named: "Missing Picture") {
			
			let expectation = expectationWithDescription("Submission")
			
			let data = UIImageJPEGRepresentation(image, 1)
			let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
			let view = storyboard.instantiateInitialViewController()!
			
			let confirmation = UIAlertController(title: "Submit?", message: "Are you sure you want to submit your application?", preferredStyle: .Alert)
			confirmation.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
			confirmation.addAction(UIAlertAction(title: "Submit", style: .Default, handler: { (action) in
				let loader = UIAlertController()
				let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
				indicator.startAnimating()
				loader.setValue(indicator, forKey: "accessoryView")
				view.presentViewController(loader, animated: true, completion: nil)
				helper.sendRequest(jsonData: serialized, imageNamed: "userPicture.jpg", imageData: data!, toURL: "https://api.jobbau.famoser.ch/1.0/submit", success: {
					self.showAlert("Submission Successful", text: "Thank you!", forDuration: 3, inView: view)
					loader.dismissViewControllerAnimated(true, completion: nil)
					
					XCTAssert(true)
					expectation.fulfill()
				}) {
					self.showAlert("Submission Failed", text: "Please try again later or contact support.", forDuration: 5, inView: view)
					loader.dismissViewControllerAnimated(true, completion: nil)
					
					XCTFail()
				}
			}))
			view.presentViewController(confirmation, animated: true, completion: nil)
		} else {
			XCTAssert(false)
		}
		
		waitForExpectationsWithTimeout(10) { (error) in
			if (error != nil) {
				XCTFail("Error! \(error?.localizedDescription)")
			}
		}
	}
	
	func showAlert(title: String, text: String, forDuration duration: NSTimeInterval, inView view: UIViewController) {
		let alert = UIAlertController(title: title, message: text, preferredStyle: .Alert)
		view.presentViewController(alert, animated: true) {
			UIView.animateWithDuration(duration, animations: {
				alert.view.alpha = 0.9999999 // dummy animation for an easy wait
			}) { (success) in
				alert.dismissViewControllerAnimated(true, completion: nil)
			}
		}
	}
	
}
