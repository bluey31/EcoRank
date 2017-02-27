//
//  ERDeviceModule.swift
//  EcoRank
//
//  Created by Brendon Warwick on 27/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import Foundation
import UIKit

class ERDeviceModule : UIView{
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceEnergyConsumptionLabel: UILabel!
    
    static var deviceName: String!
    static var energyConsumptionPerHour: Float!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.backgroundColor = ERGreen
        self.deviceNameLabel.text = ERDeviceModule.deviceName
        self.deviceEnergyConsumptionLabel.text = "\(ERDeviceModule.energyConsumptionPerHour)"
    }
    
    // Return the view when called
    class func instanceOfNib(deviceName: String!, energyConsumptionPerHour: Float!) -> ERDeviceModule {
        self.deviceName = deviceName
        self.energyConsumptionPerHour = energyConsumptionPerHour
        return UINib(nibName: "ERDeviceModule", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ERDeviceModule
    }}
