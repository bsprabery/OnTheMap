//
//  Constants.swift
//  OnTheMapProject
//
//  Created by Brittany Sprabery on 10/3/16.
//  Copyright © 2016 Brittany Sprabery. All rights reserved.
//

import Foundation
import MapKit

extension OTMClient {
    
    struct Constants {
        
        static let ParseApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        //Student Data:
        struct JSONResponseKeys {
            
            //getStudents Response:
            static let CreatedAt = "createdAt"
            static let FirstName = "firstName"
            static let LastName = "lastName"
            static let Latitude = "latitude"
            static let Longitude = "longitude"
            static let MapString = "mapString"
            static let MediaURL = "mediaURL"
            static let ObjectID = "objectId"
            static let UniqueKey = "uniqueKey"
            static let AccountKey = "key"
            static let UpdatedAt = "updatedAt"
            static let StudentDictionaries = "results"
            
            //SessionID Response:
            static let CurrentTime = "current_time"
            static let AccountDictionary = "account"
            static let SessionDictionary = "session"
            static let Expiration = "expiration"
            static let SessionID = "id"
        }

        //User Data:
        struct UserResponseKeys {
            static let UserLastName = "last_name"
            static let SocialAccounts = "social_accounts"
            static let FacebookID = "facebook_id"
            static let UserFirstName = "first_name"
            static let Key = "key"
        }
        
    }
}
