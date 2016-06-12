//
//  PhotoHelper.swift
//  JobBau
//
//  Created by Julian Dunskus on 11/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class PhotoHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	var delegate: PhotoHelperDelegate
	
	init(delegate delg: PhotoHelperDelegate) {
		delegate = delg
	}
	
	func display() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
		alert.addAction(UIAlertAction(title: "Take Photo", style: .Default) { (action: UIAlertAction) in
			self.showPhotoPicker(.Camera)
			})
		alert.addAction(UIAlertAction(title: "Choose Photo", style: .Default) { (action: UIAlertAction) in
			self.showPhotoPicker(.PhotoLibrary)
			})
		alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		delegate.viewController().presentViewController(alert, animated: true, completion: nil)
	}
	
	func showPhotoPicker(source: UIImagePickerControllerSourceType) {
		let controller = UIImagePickerController()
		controller.allowsEditing = true
		controller.delegate = self
		controller.sourceType = source
		delegate.viewController().presentViewController(controller, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		delegate.photoSelected(image)
		picker.dismissViewControllerAnimated(true, completion: nil)
	}
	
}

protocol PhotoHelperDelegate {
	
	func photoSelected(picture: UIImage)
	
	func viewController() -> UIViewController
	
}