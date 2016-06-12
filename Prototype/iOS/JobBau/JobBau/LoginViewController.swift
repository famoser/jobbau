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
		let username = usernameField.text
		let password = passwordField.text
		// TODO process these
		if let editor = storyboard?.instantiateViewControllerWithIdentifier("Editor") {
			presentViewController(editor, animated: true, completion: nil)
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