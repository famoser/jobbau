//
//  SubmissionHelper.swift
//  JobBau
//
//  Created by Julian Dunskus on 13/06/16.
//  Most of this is taken from http://stackoverflow.com/questions/29623187/upload-image-with-multipart-form-data-ios-in-swift

import UIKit

class SubmissionHelper {
	
	func sendFile(url: NSURL, fileName: String, data: NSData, completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void)) {
		
		let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
		
		request.HTTPMethod = "POST"
		
		let boundary = "--THISISMYBOUNDARY--\r\n"//generateBoundary()
		let fullData = photoDataToFormData(data, boundary: boundary, fileName: fileName)
		
		request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
		
		// REQUIRED!
		request.setValue(String(fullData.length), forHTTPHeaderField: "Content-Length")
		
		request.HTTPBody = fullData
		request.HTTPShouldHandleCookies = false
		
		let session = NSURLSession()
		let task = session.uploadTaskWithRequest(request, fromData: fullData)
		task.resume()
	}
	
	// this is a very verbose version of that function
	// you can shorten it, but i left it as-is for clarity
	// and as an example
	func photoDataToFormData(data:NSData,boundary:String,fileName:String) -> NSData {
		let fullData = NSMutableData()
		
		// 1 - Boundary should start with --
		let lineOne = "--" + boundary + "\r\n"
		fullData.appendData(lineOne.dataUsingEncoding(
			NSUTF8StringEncoding,
			allowLossyConversion: false)!)
		
		// 2
		let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
		NSLog(lineTwo)
		fullData.appendData(lineTwo.dataUsingEncoding(
			NSUTF8StringEncoding,
			allowLossyConversion: false)!)
		
		// 3
		let lineThree = "Content-Type: image/jpg\r\n\r\n"
		fullData.appendData(lineThree.dataUsingEncoding(
			NSUTF8StringEncoding,
			allowLossyConversion: false)!)
		
		// 4
		fullData.appendData(data)
		
		// 5
		let lineFive = "\r\n"
		fullData.appendData(lineFive.dataUsingEncoding(
			NSUTF8StringEncoding,
			allowLossyConversion: false)!)
		
		// 6 - The end. Notice -- at the start and at the end
		let lineSix = "--" + boundary + "--\r\n"
		fullData.appendData(lineSix.dataUsingEncoding(
			NSUTF8StringEncoding,
			allowLossyConversion: false)!)
		
		return fullData
	}
}