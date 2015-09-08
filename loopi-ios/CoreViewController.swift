//
//  CoreViewController.swift
//  loopi-ios
//
//  Created by Byrdann Fox on 9/7/15.
//  Copyright (c) 2015 Loopi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftValidator

class CoreViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

	let validator = Validator()
	
	var updateId: String!
	var deleteId: String!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// getUsers()
		// getUserById()
		// createUser()
		// updateUser()
		// deleteUser()
		
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
		
		validator.styleTransformers(success:{ (validationRule) -> Void in
			println("here")
			// clear error label
			validationRule.errorLabel?.hidden = true
			validationRule.errorLabel?.text = ""
			validationRule.textField.layer.borderColor = UIColor.greenColor().CGColor
			validationRule.textField.layer.borderWidth = 0.5
			
			}, error:{ (validationError) -> Void in
				println("error")
				validationError.errorLabel?.hidden = false
				validationError.errorLabel?.text = validationError.errorMessage
				validationError.textField.layer.borderColor = UIColor.redColor().CGColor
				validationError.textField.layer.borderWidth = 1.0
		})
		
		validator.registerField(emailTextField, errorLabel: emailMessageLabel, rules: [RequiredRule(), EmailRule()])
		
	}
	
	func validationSuccessful() {
		println("Validation Success!")
		// pass data to the createUser() method
	}
	
	func validationFailed(errors:[UITextField:ValidationError]) {
		println("Validation FAILED!")
	}
	
	func hideKeyboard(){
		self.view.endEditing(true)
	}
	
	@IBOutlet weak var emailMessageLabel: UILabel!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var submitButton: UIButton!
	@IBAction func submitButtonPressed(sender: UIButton) {
		validator.validate(self)
	}
	
	// Create a user store, and look at how to make use of the Singleton Pattern
	func extractUsersData(u: [JSON], i: Int) {
		if let name = u[i]["name"].string {
			println(name)
		} else {
			println("Name parse error")
		}
		if let email = u[i]["email"].string {
			println(email)
		} else {
			println("Email parse error")
		}
		if let id = u[i]["_id"].string {
			println(id)
		} else {
			println("ID parse error")
		}
	}
	
	func getUsers() {
		var getEndpoint = "http://localhost:3000/collections/test/"
		Alamofire.request(.GET, getEndpoint).validate()
			.responseJSON { (request, response, data, error) in
				if let e = error {
					println(e)
				} else if let d: AnyObject = data {
					let users = JSON(d)
					if let u = users.array {
						for var i = 0; i < u.count; ++i {
							self.extractUsersData(u, i: i)
						}
					} else {
						println("Users parse error")
					}
				}
		}
	}
	
	func extractUserData(user: JSON) {
		if let name = user["name"].string {
			println(name)
		} else {
			println("Name parse error")
		}
		if let email = user["email"].string {
			println(email)
		} else {
			println("Email parse error")
		}
		if let id = user["_id"].string {
			println(id)
		} else {
			println("ID parse error")
		}
	}
	
	func getUserById() {
		var getEndpoint = "http://localhost:3000/collections/test/55ed012c3eb9e7ac1940fc4a"
		Alamofire.request(.GET, getEndpoint).validate()
			.responseJSON { (request, response, data, error) in
				if let e = error {
					println(e)
				} else if let d: AnyObject = data {
					let user = JSON(d)
					self.extractUserData(user)
				} else {
					println("User parse error")
				}
		}
	}
	
	func createUser() {
		var postEndpoint = "http://localhost:3000/collections/test/"
		var newUser = [
			"name": "Richard Wayne Gary Wayne",
			"email": "dummy@dummie.io"
		]
		Alamofire.request(.POST, postEndpoint, parameters: newUser, encoding: .JSON)
			.validate().responseJSON { (request, response, data, error) in
				if let e = error {
					println(e)
				} else if let data: AnyObject = data {
					let u = JSON(data)
					println(u)
					// just for now...
					if let id = u["_id"].string {
						self.updateId = id
						self.deleteId = id
					}
				}
		}
	}
	
	func updateUser() {
		var updateEndpoint = "http://localhost:3000/collections/test/\(updateId)"
		var updatedUser = [
			"name": "Xternals",
			"email": "xternals@xternals.io"
		]
		Alamofire.request(.PUT, updateEndpoint, parameters: updatedUser, encoding: .JSON).validate().responseJSON { (request, response, data, error) in
			if let e = error {
				println(e)
			} else if let data: AnyObject = data {
				let u = JSON(data)
				println(u)
			}
		}
	}
	
	func deleteUser() {
		var deleteEndpoint = "http://localhost:3000/collections/test/\(deleteId)"
		Alamofire.request(.DELETE, deleteEndpoint).validate()
			.responseJSON { (request, response, data, error) in
				if let e = error {
					println(e)
				} else if let data: AnyObject = data {
					let m = JSON(data)
					println(m)
				}
		}
	}

}