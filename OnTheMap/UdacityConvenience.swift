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
    func loginForPublicUserInfo(email: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        let request = customURLRequest(withBaseURLString: ConstantsUdacity.URL.baseURL, headerFields: ["Accept":"application/json", "Content-Type":"application/json"], HTTPMethod: "POST", HTTPBody: "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}")
        
        guard let urlRequest = request else {
            let userInfo = [NSLocalizedDescriptionKey:"Invalid URLRequest"]
            completionHandlerForLogin(false, NSError(domain: "loginForPublicUserInfo", code: 1, userInfo: userInfo))
            return
        }
        
        udacityDataProvider(URLrequest: urlRequest) { (result, error) in
            
            guard (error == nil) else { completionHandlerForLogin(false, error); return }
            
            guard let account = result?[ConstantsUdacity.APIResponseKeys.account] as? [String:AnyObject], let accountKey = account[ConstantsUdacity.APIResponseKeys.key] as? String else {
                let userInfo = [NSLocalizedDescriptionKey:"No accountKey returned"]
                completionHandlerForLogin(false, NSError(domain: "loginForSessionID", code: 1, userInfo: userInfo))
                return
            }
            self.parseClient.accountKey = accountKey
            
            //Get public user information from accountKey
            let infoRequest = self.customURLRequest(withBaseURLString: ConstantsUdacity.URL.userPublicData + "/\(accountKey)", headerFields: nil, HTTPMethod: "GET", HTTPBody: nil)
            
            guard let newRequest = infoRequest else {
                let userInfo = [NSLocalizedDescriptionKey:"Invalid URLRequest"]
                completionHandlerForLogin(false, NSError(domain: "loginForPublicUserInfo", code: 1, userInfo: userInfo))
                return
            }
            
            self.udacityDataProvider(URLrequest: newRequest, completionHandlerForUdacityDataProvider: { (result, error) in
                
                guard (error == nil) else { completionHandlerForLogin(false, error); return }
                
                guard let user = result?[ConstantsUdacity.APIResponseKeys.user] as? [String:AnyObject], let firstName = user[ConstantsUdacity.APIResponseKeys.firstName] as? String, let lastName = user[ConstantsUdacity.APIResponseKeys.lastName] as? String else {
                    
                    let userInfo = [NSLocalizedDescriptionKey:"No public userInfo returned in JSON"]
                    completionHandlerForLogin(false, NSError(domain: "loginForPublicUserInfo", code: 1, userInfo: userInfo))
                    return
                }
                
                self.parseClient.firstName = firstName
                self.parseClient.lastName = lastName
                
                completionHandlerForLogin(true, nil)
            })
            
            
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
