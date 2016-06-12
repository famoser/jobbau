//
//  EditorViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 10/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class EditorViewController: UITableViewController, PhotoHelperDelegate {
	
	@IBOutlet weak var pictureView: UIImageView!
	
	var helper: PhotoHelper!
	var photo: UIImage?
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		// picture
		if indexPath.section == 0 {
			helper.display()
		}
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	func updateImage() {
		if let image = photo {
			pictureView.image = image
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		helper = PhotoHelper(delegate: self)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// photo helper delegate methods
	
	func photoSelected(picture: UIImage) {
		photo = picture
		updateImage()
	}
	
	func viewController() -> UIViewController {
		return self
	}
	
}