//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 13/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func loginForSessionID(email: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let request = customURLRequest(withBaseURLString: ConstantsUdacity.URL.baseURL, headerFields: ["Accept":"application/json", "Content-Type":"application/json"], HTTPMethod: "POST", HTTPBody: "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}")
        
        guard let urlRequest = request else { print("UdacityClient/LoginForSessionID: Invalid URLRequest"); return }
        
        udacityDataProvider(URLrequest: urlRequest) { (result, error) in
            
            guard (error == nil) else { completionHandlerForLogin(false, error); return }
            
            if (result != nil) {
                
                guard let session = result?[ConstantsUdacity.APIResponseKeys.session] as? [String:AnyObject], let sessionID = session[ConstantsUdacity.APIResponseKeys.id] as? String else {
                    let userInfo = [NSLocalizedDescriptionKey:"NO SessionID"]
                    completionHandlerForLogin(false, NSError(domain: "loginForSessionID", code: 1, userInfo: userInfo))
                    return
                }
                
                self.sessionID = sessionID
                completionHandlerForLogin(true, nil)
                
            }
        }
    }
}
