//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 14/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation

extension ParseClient {
    
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
            
            for result in results {
                let student = StudentInformation(fromDictionary: result)
                self.studentInformation.append(student)
            }
         completionHandlerForLoadRecents(true, nil)
        }
    }
}
