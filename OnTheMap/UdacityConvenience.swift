//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 13/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    //LogIn
    func loginForSessionID(email: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let request = customURLRequest(withBaseURLString: ConstantsUdacity.URL.baseURL, headerFields: ["Accept":"application/json", "Content-Type":"application/json"], HTTPMethod: "POST", HTTPBody: "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}")
        
        guard let urlRequest = request else { print("UdacityClient/LoginForSessionID: Invalid URLRequest"); return }
        
        udacityDataProvider(URLrequest: urlRequest) { (result, error) in
            
            guard (error == nil) else { completionHandlerForLogin(false, error); return }
            
            completionHandlerForLogin(true, nil)
        }
    }
    
    // LogOut
    func logout(completionHandlerForLogout: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let request = customURLRequest(withBaseURLString: ConstantsUdacity.URL.baseURL, headerFields: nil, HTTPMethod: ConstantsUdacity.URLRequest.deleteMethod, HTTPBody: nil)
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        guard let cookie = xsrfCookie, var urlRequest = request else {
            let userInfo = [NSLocalizedDescriptionKey:"Logout Fail"]
            completionHandlerForLogout(false, NSError(domain: "logout", code: 1, userInfo: userInfo))
            return
        }
        
        urlRequest.addValue(cookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        
        udacityDataProvider(URLrequest: urlRequest) { (result, error) in
            
            if let error = error { completionHandlerForLogout(false, error); return }
            
            if let _ = result {
                completionHandlerForLogout(true, nil)
            } else {
                let userInfo = [NSLocalizedDescriptionKey:"result is empty"]
                completionHandlerForLogout(false, NSError(domain: "logout", code: 1, userInfo: userInfo))
                return
            }
        }
    }
}
