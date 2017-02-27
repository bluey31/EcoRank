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
    
    override func awakeFromNib() {
        backgroundView.backgroundColor = ERGreen
    }
    
    init(x: Int, deviceName: String, energyConsumptionPerHour: Float) {
        self.deviceNameLabel.text = deviceName
        self.deviceEnergyConsumptionLabel.text = "\(energyConsumptionPerHour)"
        super.init(frame: CGRect(x: x, y: 0, width: 200, height: 144))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
