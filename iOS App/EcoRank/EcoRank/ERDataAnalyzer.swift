//
//  ERDataAnalyzer.swift
//  EcoRank
//
//  Created by Brendon Warwick on 28/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import Foundation
import UIKit

class ERLightDataAnalyzer {
    var intensity : Int
    var onState : Bool
    var currentDate: Date!
    var id : String
    
    init(intensity: Int, onState: Bool, id: String) {
        self.currentDate = Date.init(timeIntervalSinceNow: 0.00)
        self.intensity = intensity
        self.onState = onState
        self.id = id
    }
    
    func calculateLightBulbPowerUsage(obj: ERLightDataAnalyzer) -> Float{
        if obj.onState {
            return Float(obj.intensity) * powerInfo[obj.id]!
        }
        return 0
    }
    
    func incrementEnergyUsedForDay() {
        
        var temp: Float = 0.0
        
        // Fetch current energy consumption
        if let currentEnergyConsumption = UserDefaults.standard.object(forKey: "energyConsumption") {
            if self.onState {
                temp = currentEnergyConsumption as! Float
                temp += Float(self.intensity) * powerInfo[self.id]! * 60.0
            }
            
            print("Current Energy Consumption: \(currentEnergyConsumption)")
            UserDefaults.standard.set(currentEnergyConsumption, forKey: "energyConsumption")
        }
        
        UserDefaults.standard.set(temp, forKey: "energyConsumption")
        
    }
    
    func generateData(obj: ERLightDataAnalyzer) -> [String: Any]{
        let dict: [String: Any] = ["energyUsed":self.calculateLightBulbPowerUsage(obj: obj), "day":currentDate]
        print(dictToJSON(dict: dict))
        return dictToJSON(dict: dict)
    }
}

class ERThermostatDataAnalyzer {
    var startingTemp : Float
    var endTemp : Float
    var onState : Int
    var currentDate: Date!
    var id : String
    
    init(startTemp: Float, endTemp: Float, onState: Int, id: String) {
        self.currentDate = Date.init(timeIntervalSinceNow: 0.00)
        self.startingTemp = startTemp
        self.endTemp = endTemp
        self.onState = onState
        self.id = id
    }
    
    func calculateThermostatPowerUsage(obj: ERThermostatDataAnalyzer) -> Float{
        if obj.onState > 0{
            return 69
        }
        return 0
    }
    
    func incrementEnergyUsedForDay() {
        
        var temp: Float = 0.0
        
        // Fetch current energy consumption
        if let currentEnergyConsumption = UserDefaults.standard.object(forKey: "energyConsumption") {
            if self.onState > 0{
                temp = currentEnergyConsumption as! Float
                temp += 1.000
                
                UserDefaults.standard.set(temp, forKey: "energyConsumption")
            }
        }
        
        print("Current Energy Consumption: \(temp)")
        UserDefaults.standard.set(temp, forKey: "energyConsumption")
    }
    
    func commitDataForDay(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let stringDate = dateFormatter.string(from: currentDate)
    }
}

func dictToJSON(dict: [String: Any]) -> [String: Any]{
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        
        let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
        
        // you can now cast it with the right type
        if let dictFromJSON = decoded as? [String: Any] {
            print(dictFromJSON)
            return dictFromJSON
        }
    } catch {
        print(error.localizedDescription)
        return [:]
    }
    return [:]
}
