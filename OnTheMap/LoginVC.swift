//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 12/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.init(red: 255/255.0, green: 143/255.0, blue: 0.0, alpha: 1)
        
    }
}
