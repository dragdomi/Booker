//
//  LoginViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 16/06/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	
//	@IBAction func loginPressed(_ sender: UIButton) {
//		if let email = emailTextField.text, let password = passwordTextField.text {
//			loginUser(email, password)
//		}
//	}
//	
//	func loginUser(_ email: String, _ password: String) {
//		Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
//			self.checkIfLoginFailed(error: error)
//		}
//	}
//	
//	func checkIfLoginFailed(error: Error?) {
//		if let error = error {
//			print(error)
//		} else {
//			if let booksViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.books) as? BooksViewController {
//				navigationController?.pushViewController(booksViewController, animated: true)
//			}
//		}
//	}
}
