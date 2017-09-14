//
//  StudentInformatiom.swift
//  OnTheMap
//
//  Created by Nathaniel Remy on 14/09/2017.
//  Copyright © 2017 Nathaniel Remy. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    let firstName: String?
    let lastName: String?
    let latitude: Float?
    let longitude: Float?
    let mapString: String?
    let mediaURL: String?
    let objectID: String?
    let uniqueKey: String?
    
    init(fromDictionary dictionary: [String:AnyObject]) {
        
        if let firstName = dictionary[ConstantsParse.JSONResponseKeys.firstName] as? String {
            self.firstName = firstName
        } else {
            self.firstName = nil
        }
        
        if let lastName = dictionary[ConstantsParse.JSONResponseKeys.lastName] as? String {
            self.lastName = lastName
        } else {
            self.lastName = nil
        }
        
        if let latitude = dictionary[ConstantsParse.JSONResponseKeys.latitude] as? Float {
            self.latitude = latitude
        } else {
            self.latitude = nil
        }
        
        if let longitude = dictionary[ConstantsParse.JSONResponseKeys.longitude] as? Float {
            self.longitude = longitude
        } else {
            self.longitude = nil
        }
        
        if let mapString = dictionary[ConstantsParse.JSONResponseKeys.mapString] as? String {
            self.mapString = mapString
        } else {
            self.mapString = nil
        }
        
        if let mediaUrl = dictionary[ConstantsParse.JSONResponseKeys.mediaURL] as? String {
            self.mediaURL = mediaUrl
        } else {
            self.mediaURL = nil
        }
        
        if let objectID = dictionary[ConstantsParse.JSONResponseKeys.objectID] as? String {
            self.objectID = objectID
        } else {
            self.objectID = nil
        }
        
        if let uniqueKey = dictionary[ConstantsParse.JSONResponseKeys.uniqueKey] as? String {
            self.uniqueKey = uniqueKey
        } else {
            self.uniqueKey = nil
        }
    }
}
