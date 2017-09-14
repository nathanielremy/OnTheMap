//
//  ConstantsUdacity.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 13/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation

class ConstantsUdacity {
    
    struct URL {
        static let baseURL = "https://www.udacity.com/api/session"
        static let udacitySignUpURL = "https://www.udacity.com/account/auth#!/signup"
    }
    
    struct URLRequest {
        static let postMethod = "POST"
        static let deleteMethod = "DELETE"
    }
    
    struct APIResponseKeys {
        static let session = "session"
        static let id = "id"
    }
}
