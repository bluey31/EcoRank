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
    
    func incrementEnergyUsedForDay() {
        var temp: Float = 0.0
        if let currentEnergyConsumption = UserDefaults.standard.object(forKey: "energyConsumption") {
            if self.onState {
                temp = currentEnergyConsumption as! Float
                temp += Float(self.intensity) * powerInfo[self.id]! * 60.0
            }
            if let currentCounter = UserDefaults.standard.object(forKey: "lightCounter") {
                var tempCounter = currentCounter as! Float
                 UserDefaults.standard.set(tempCounter += 1, forKey: "lightCounter")
            } else {
                UserDefaults.standard.set(1, forKey: "lightCounter")
            }
           
        }
        print("Updating to \(temp)")
        UserDefaults.standard.set(temp, forKey: "energyConsumption")
        
        if UserDefaults.standard.object(forKey: "lightCounter") as! Int == 1440 {
            //PUSH
            UserDefaults.standard.set(0, forKey: "lightCounter")
        }
        
    }
    
    func generateData(obj: ERLightDataAnalyzer) -> [String: Any]{
        let energyUsed = UserDefaults.standard.object(forKey: "energyConsumption") as! Float
        let dict: [String: Any] = ["energyUsed": energyUsed, "day":commitDataForDay()]
        print(dictToJSON(dict: dict))
        return dictToJSON(dict: dict)
    }
    
    func commitDataForDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: currentDate)
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
            if let currentCounter = UserDefaults.standard.object(forKey: "thermoCounter") {
                var tempCounter = currentCounter as! Float
                UserDefaults.standard.set(tempCounter += 1, forKey: "thermoCounter")
            } else {
                UserDefaults.standard.set(1, forKey: "thermoCounter")
            }
        }
        if UserDefaults.standard.object(forKey: "thermoCounter") as! Int == 1440 {
            //PUSH
            UserDefaults.standard.set(0, forKey: "thermoCounter")
            
        }
        
        UserDefaults.standard.set(temp, forKey: "energyConsumption")
    }
    
    func commitDataForDay() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: currentDate)
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

