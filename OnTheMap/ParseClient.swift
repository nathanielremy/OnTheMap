//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 14/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation

class ParseClient {
    
    //Stored properties
    var accountKey: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var mapString: String? = nil
    var mediaURL: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var studentInformation = [StudentInformation]()
    
    func parseDataProvider(URLRequest request: URLRequest, completionHandlerForParseDataProvider: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void ) {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            func displayError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForParseDataProvider(nil, NSError(domain: "parseDataProvider", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else { displayError(error!.localizedDescription); return }
            
            guard let HTTPStatusCode = (response as? HTTPURLResponse)?.statusCode, (HTTPStatusCode >= 200) && (HTTPStatusCode <= 299) else { displayError("Your request returned a statusCode other than 2xxx"); return }
            
            guard let data = data else { displayError("No data was returned by the request"); return }
            
            var parsedJSON: AnyObject? = nil
            
            // Parse raw data into JSON
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                parsedJSON = json
            } catch {
                displayError("Could not turn raw data into a foundation object")
            }
            
            if let json = parsedJSON {
                completionHandlerForParseDataProvider(json, nil)
            } else {
                displayError("Data is empty")
            }
        }
        task.resume()
    }
    
    //Create a custom URLRequest
    func customURLRequest(from url: URL, HTTPBody body: String?, headerFields headers: [String:String]?) -> URLRequest {
        
        let request = NSMutableURLRequest(url: url)
        request.addValue(ConstantsParse.APIHeaderValues.apiKey, forHTTPHeaderField: ConstantsParse.APIHeaderKeys.key)
        request.addValue(ConstantsParse.APIHeaderValues.applicationID, forHTTPHeaderField: ConstantsParse.APIHeaderKeys.ID)
        
        if let jsonBody = body {
            request.httpBody = jsonBody.data(using: .utf8)
        }
        
        guard let headers = headers else { return request as URLRequest }
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request as URLRequest
    }
    
    //Create URL from parameters
    func parseURLFromParameters(_ parameters: [String:String], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ConstantsParse.URL.urlScheme
        components.host = ConstantsParse.URL.urlHost
        components.path = ConstantsParse.URL.urlPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: Singleton
    static func singleton() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
