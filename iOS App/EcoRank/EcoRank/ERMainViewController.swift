//
//  ERLoginViewController.swift
//  EcoRank
//
//  Created by Jay Lees on 27/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import UIKit

class ERMainViewController: UIViewController {

    @IBOutlet weak var cloudTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var horizontalDeviceModuleParentView: UIView!
    @IBOutlet weak var horizontalDeviceModuleScrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        // Beginning value for constraint so the cloud is off the screen
        cloudTopConstraint.constant = -148
    }
    override func viewDidAppear(_ animated: Bool) {
        animateClouds()
        self.view.backgroundColor = ERSkyBlue
        self.horizontalDeviceModuleParentView.backgroundColor = UIColor.clear
        addTestBoxes()
    }
    
    func animateClouds(){
        UIView.animate(withDuration: 0.75, animations: {
            // finishing position for the cloud
            self.cloudTopConstraint.constant = -43
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            self.animateText()
        })
    }
    
    func addTestBoxes(){
        let gap = 20
        
        for i in 0...6 {
            let newX = (i * 200) + (i * gap)
            let newDevModule: ERDeviceModule = ERDeviceModule.instanceOfNib(deviceName: "Light Blub af", energyConsumptionPerHour: 69.69)
            newDevModule.frame = CGRect(x: newX, y: 0, width: 200, height: 144)
            horizontalDeviceModuleScrollView.addSubview(newDevModule)
        }
    }
    
    func animateText() {
        
    }
}
