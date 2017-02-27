//
//  ERUser.swift
//  EcoRank
//
//  Created by Brendon Warwick on 27/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import Foundation
import UIKit

class ERUser {
    var userId: Int!
    var username: String!
    var longitude: Float!
    var latitude: Float!
    var houseClassifier: Int!
    
    init(id: Int, username: String!, longitude: Float!, latitude: Float!, houseClassifier: Int!) {
        self.userId = id
        self.username = username
        self.longitude = longitude
        self.latitude = latitude
        self.houseClassifier = houseClassifier
    }
}
