//
//  TextFieldDelegate.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 15/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
