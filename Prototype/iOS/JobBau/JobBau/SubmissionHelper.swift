//
//  SubmissionHelper.swift
//  JobBau
//
//  Created by Julian Dunskus on 13/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class SubmissionHelper {
	
	static var sharedInstance = SubmissionHelper()
	
	func sendRequest(jsonData json: NSData, imageNamed name: String, imageData: NSData, toURL url: String) {
		let manager = AFHTTPSessionManager()
		manager.POST(url, parameters: nil, constructingBodyWithBlock:
			{ (formData) in
				formData.appendPartWithFormData(json, name: "json")
				formData.appendPartWithFileData(imageData, name: "imageFile", fileName: name, mimeType: "image/jpeg")
			}, progress: nil, success:
			{ (dataTask, response) in
				print("Got response: \(response)")
			}, failure:
			{ (dataTask, error) in
				print("Got error: \(error.localizedDescription)")
				let data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData
				let string = NSString(data: data, encoding: NSUTF8StringEncoding)
				print(string)
		})
	}
}