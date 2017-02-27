//
//  ERLoginViewController.swift
//  EcoRank
//
//  Created by Jay Lees on 27/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import UIKit
import HomeKit

class ERMainViewController: UIViewController, HMHomeManagerDelegate {

    @IBOutlet weak var cloudTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var horizontalDeviceModuleParentView: UIView!
    @IBOutlet weak var horizontalDeviceModuleScrollView: UIScrollView!
    @IBOutlet weak var horizontalDeviceModuleContainerView: UIView!
    @IBOutlet weak var horizontalDeviceModuleWidth: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        // Beginning value for constraint so the cloud is off the screen
        cloudTopConstraint.constant = -148
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateClouds()
        self.view.backgroundColor = ERSkyBlue
        self.horizontalDeviceModuleParentView.backgroundColor = UIColor.clear
        addTestBoxes()
        testHomeKit()
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
        let deviceArraySize = 6
        
        // Width of module = 200, width of gap = 20 * the amount of devices
        let widthOfContainer = 220*deviceArraySize
        horizontalDeviceModuleWidth.constant = CGFloat(widthOfContainer)
        self.view.layoutIfNeeded()
        
        for j in 0...deviceArraySize-1 {
            // 16 is our offset
            let newX = (j * 200) + (j * gap) + 16
            let newDevModule: ERDeviceModule = ERDeviceModule.instanceOfNib(deviceName: "Light Blub af", energyConsumptionPerHour: 69.69)
            newDevModule.frame = CGRect(x: newX, y: 0, width: 200, height: 144)
            horizontalDeviceModuleContainerView.addSubview(newDevModule)
        }
    }
    
    func animateText() {
        
    }
    
    func testHomeKit(){
        let homeMananger = HMHomeManager()
        homeMananger.delegate = self
        let home = homeMananger.primaryHome!
        for room in home.rooms {
            for accessory in room.accessories {
                print("Name : \(accessory.name), UUID \(accessory.uniqueIdentifier)")
            }
        }
    }
}
