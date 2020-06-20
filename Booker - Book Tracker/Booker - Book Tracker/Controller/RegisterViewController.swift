//
//  RegisterViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 16/06/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	
	@IBAction func registerPressed(_ sender: UIButton) {
		if let email = emailTextField.text, let password = passwordTextField.text {
			registerUser(email, password)
		}
	}
	
	func registerUser (_ email: String, _ password: String) {
		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			self.checkIfRegisterFailed(error: error)
		}
	}
	
	func checkIfRegisterFailed(error: Error?) {
		if let error = error {
			print(error)
		} else {
			if let booksViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.books) as? BooksViewController {
				navigationController?.pushViewController(booksViewController, animated: true)
			}
		}
	}
}
