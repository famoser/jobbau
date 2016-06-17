//
//  ViewController.swift
//  JobBau
//
//  Created by Julian Dunskus on 10/06/16.
//  Copyright © 2016 Julian Dunskus. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	
	@IBAction func loginPressed(button: UIButton?) {
		//let username = usernameField.text
		if let password = passwordField.text {
			if password == "jobbau01" {
				if let navigator = storyboard?.instantiateViewControllerWithIdentifier("Navigation") {
					presentViewController(navigator, animated: true, completion: nil)
				}
			} else {
				showAlert("Incorrect Password!", text: nil, forDuration: 1)
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		if textField == usernameField {
			usernameField.resignFirstResponder()
			passwordField.becomeFirstResponder()
		} else {
			passwordField.resignFirstResponder()
			loginPressed(nil)
		}
		return false
	}
	
}
