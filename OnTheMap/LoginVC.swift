//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 12/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // Interface Builder Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Stored Properties
    lazy var udacityClient: UdacityClient = {
        let client = UdacityClient.singleton()
        return client
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTextFields()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        udacityClient.loginForPublicUserInfo(email: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.manageLoginErrors(error: error!)
                }
            } else if success {
                DispatchQueue.main.async {
                    self.completeLogIn()
                }
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let udacitySignUpURL = URL(string: ConstantsUdacity.URL.udacitySignUpURL)
        guard let url = udacitySignUpURL else { print("LoginVC/signUpPressed: URL could not be constructed"); return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension LoginVC {
    
    func completeLogIn() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as? UINavigationController
        
        if let controller = controller {
            self.present(controller, animated: true, completion: nil)
        } else {
            displayAlerView(withTitle: "ERROR", message: "No StoryBoard... Report this problem", action: "Okay")
        }
    }
    
    // Network or Credential erros ?
    func manageLoginErrors(error: NSError) {
        if error.localizedDescription == "The Internet connection appears to be offline." || error.localizedDescription == "The request timed out." {
                self.displayAlerView(withTitle: "Poor Internet Connection", message: "Try to re-connenct", action: "Okay")
            
        } else if error.localizedDescription == "Your request returned a statusCode other than 2xxx" {
                self.displayAlerView(withTitle: "Email or password Incorrect", message: "Please use valid login credentials", action: "Okay")
        }
    }
    
    // Display UIAlertControllers in case of errors
    func displayAlerView(withTitle title: String, message: String, action: String) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .cancel, handler: nil)
        alertView.addAction(action)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func configureTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
