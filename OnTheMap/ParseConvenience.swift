//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 14/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func addLocation(completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
//       print("uniqueKey: \(self.accountKey)\nfirstName: \(self.firstName)\nlastName: \(self.lastName)\nmapString: \(self.mapString)\nmediaURL: \(self.mediaURL)\nlatitude: \(self.latitude)\nlongitude: \(self.longitude)")
//        
        
        guard let uniqueKey = self.accountKey, let firstName = self.firstName, let lastName = self.lastName, let mapString = self.mapString, let mediaURL = self.mediaURL, let lat = self.latitude, let long = self.longitude else {
            print("NOOOOO")
            return
        }
        
        print("uniqueKey: \(uniqueKey)\nfirstName: \(firstName)\nlastName: \(lastName)\nmapString: \(mapString)\nmediaURL: \(mediaURL)\nlatitude: \(lat)\nlongitude: \(long)")
        // YOU ARE HEREE
        
    }
    
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
            
            self.studentInformation.removeAll()
            
            for result in results {
                let student = StudentInformation(fromDictionary: result)
                self.studentInformation.append(student)
            }
         completionHandlerForLoadRecents(true, nil)
        }
    }
}
