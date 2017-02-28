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
    var userId: Int
    var username: String
    var longitude: Float
    var latitude: Float
    var houseClassifier: Int
    var energyUsed: Float
    
    init(id: Int, username: String!, longitude: Float!, latitude: Float!, houseClassifier: Int!) {
        self.userId = id
        self.username = username
        self.longitude = longitude
        self.latitude = latitude
        self.houseClassifier = houseClassifier
        self.energyUsed = 0
    }
    
    init(id: Int, energyUsed: Float) {
        self.userId = id
        self.energyUsed = energyUsed
        self.username = ""
        self.longitude = 0.0
        self.latitude = 0.0
        self.houseClassifier = 0
    }
}
