//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 14/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // Convenience method to add location
    func addLocation(completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {

        guard let uniqueKey = self.accountKey, let firstName = self.firstName, let lastName = self.lastName, let mapString = self.mapString, let mediaURL = self.mediaURL, let lat = self.latitude, let long = self.longitude else {
            print("NOOOOO")
            return
        }
        let httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(lat), \"longitude\": \(long)}"
        
        let parameters = [String:String]()
        let url = parseURLFromParameters(parameters)
        let request = customURLRequest(from: url, HTTPBody: httpBody, headerFields: [ConstantsParse.QueryItemKeys.contentType:ConstantsParse.QueryItemValues.contentTypeValue], method: ConstantsParse.URLRequest.postMethod)
        
        parseDataProvider(URLRequest: request) { (result, error) in
            
            guard (error == nil) else { completionHandler(false, error!); return }
            
            if let _ = result {
                completionHandler(true, nil)
            } else {
                let userInfo = [NSLocalizedDescriptionKey:"No error but also no result when adding location"]
                completionHandler(false, NSError(domain: "addLocation", code: 1, userInfo: userInfo))
                return
            }
            
        }
        
    }
    
    //convenience method to load recently added locations
    func loadRecents(completionHandlerForLoadRecents: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {
        
        let parameters = [ConstantsParse.QueryItemKeys.limit:ConstantsParse.QueryItemValues.limit, ConstantsParse.QueryItemKeys.order:ConstantsParse.QueryItemValues.order]
        let url = parseURLFromParameters(parameters)
        let request = customURLRequest(from: url, HTTPBody: nil, headerFields: nil)
        
        parseDataProvider(URLRequest: request) { (result, error) in
            
            guard (error == nil) else { completionHandlerForLoadRecents(false, error!); return }
            
            guard let results = result?[ConstantsParse.JSONResponseKeys.results] as? [[String:AnyObject]] else {
                
                let userInfo = [NSLocalizedDescriptionKey:"results doesnt contain any results"]
                completionHandlerForLoadRecents(false, NSError(domain: "loadRecents", code: 1, userInfo: userInfo))
                return
            }
            
            StudentInformation.studentArray.removeAll()
            
            for result in results {
                let student = StudentInformation(fromDictionary: result)
                StudentInformation.studentArray.append(student)
            }
         completionHandlerForLoadRecents(true, nil)
        }
    }
}
