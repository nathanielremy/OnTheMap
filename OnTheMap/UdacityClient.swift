//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 13/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation

class UdacityClient {
    
    // Stored Properties
    lazy var parseClient: ParseClient = {
        let client = ParseClient.singleton()
        return client
    }()
    
    func udacityDataProvider(URLrequest request: URLRequest, completionHandlerForUdacityDataProvider: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        let task = URLSession.shared
        .dataTask(with: request) { (data, response, error) in
            
            func displayError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForUdacityDataProvider(nil, NSError(domain: "udacityDataProvider", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else { displayError(error!.localizedDescription); return }
            
            guard let HTTPStatusCode = (response as? HTTPURLResponse)?.statusCode, (HTTPStatusCode >= 200) && (HTTPStatusCode <= 299) else { displayError("Your request returned a statusCode other than 2xxx"); return }
            
            guard let data = data else { displayError("No data was returned by the request"); return }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            var parsedJSON: AnyObject? = nil
            
            // Turn the raw data into JSON then a foundation object
            do {
                
                let json = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
                parsedJSON = json
                
            } catch {
                displayError("Could not turn raw data into a foundation object")
            }
            
            guard let parsedResult = parsedJSON else { displayError("parsedJSON did not fall through"); return }
            
            completionHandlerForUdacityDataProvider(parsedResult, nil)
            
        }
        task.resume()
    }
    
    // Create a custom URLRequest
    func customURLRequest(withBaseURLString urlString: String, headerFields headers: [String:String]?, HTTPMethod method: String, HTTPBody body: String?) -> URLRequest? {
        
        guard let url = URL(string: urlString) else { return nil }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method
        if let jsonBody = body {
            request.httpBody = jsonBody.data(using: .utf8)
        }
        
        guard let headers = headers else { return request as URLRequest }
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request as URLRequest
    }
    
    // MARK: Singleton
    static func singleton() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
