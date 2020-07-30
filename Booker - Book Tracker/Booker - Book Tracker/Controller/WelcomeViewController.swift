//
//  WelcomeViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 15/06/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
	@IBOutlet weak var titleLabel: UILabel!
	
	@IBAction func registerPressed(_ sender: UIButton) {
		if let registerViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.register) as? RegisterViewController {
			navigationController?.pushViewController(registerViewController, animated: true)
		}
	}
	
	@IBAction func loginPressed(_ sender: UIButton) {
		if let loginViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.login) as? LoginViewController {
			navigationController?.pushViewController(loginViewController, animated: true)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isNavigationBarHidden = false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		titleLabel.text = "Booker 📚"
		if let booksViewController = storyboard?.instantiateViewController(identifier: Constants.ViewControllers.books) as? BooksViewController {
			navigationController?.pushViewController(booksViewController, animated: true)
		}
	}
}
