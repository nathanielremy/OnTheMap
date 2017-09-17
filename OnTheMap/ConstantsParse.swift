//
//  ConstantsParse.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 14/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation

class ConstantsParse {
    
    struct URL {
        
        static let urlScheme = "https"
        static let urlHost = "parse.udacity.com"
        static let urlPath = "/parse/classes/StudentLocation"
    }
    
    struct APIHeaderKeys {
        static let ID = "X-Parse-Application-Id"
        static let key = "X-Parse-REST-API-Key"
    }
    
    struct APIHeaderValues {
        static let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct URLRequest {
        static let postMethod = "POST"
    }
    
    struct JSONResponseKeys {
        static let results = "results"
        static let objectID = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    struct QueryItemKeys {
        static let limit = "limit"
        static let order = "order"
        static let contentType = "Content-Type"
    }
    
    struct QueryItemValues {
        static let limit = "100"
        static let order = "-updatedAt"
        static let contentTypeValue = "application/json"
    }
    
}
