//
//  ERLoginViewController.swift
//  EcoRank
//
//  Created by Jay Lees on 27/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import UIKit
import HomeKit

class ERMainViewController: UIViewController, HMHomeManagerDelegate, HMAccessoryBrowserDelegate {

    @IBOutlet weak var cloudTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var horizontalDeviceModuleParentView: UIView!
    @IBOutlet weak var horizontalDeviceModuleScrollView: UIScrollView!
    @IBOutlet weak var horizontalDeviceModuleContainerView: UIView!
    @IBOutlet weak var horizontalDeviceModuleWidth: NSLayoutConstraint!
    let homeManager = HMHomeManager()
    let browser = HMAccessoryBrowser()
    var accessories = [HMAccessory]()
    var accNumber = 0
    
    override func viewWillAppear(_ animated: Bool) {
        // Beginning value for constraint so the cloud is off the screen
        cloudTopConstraint.constant = -148
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateClouds()
        self.view.backgroundColor = ERSkyBlue
        self.horizontalDeviceModuleParentView.backgroundColor = UIColor.clear
        
        //HomeKit
        homeManager.delegate = self
        browser.delegate = self
        testHomeKit()
    }
    
    //MARK: Accessory delegate methods
    
    func stopSearching(){
        browser.stopSearchingForNewAccessories()
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        let primaryHome = homeManager.primaryHome!
        print("found new accessor: \(accessory)")
        accNumber += 1
        primaryHome.addAccessory(accessory, completionHandler: { error -> Void in
            if error != nil {
                print("Error whilst trying to add accessory \(error.debugDescription)")
            }
            self.accessories.append(accessory)
            //if self.accNumber == self.accessories.count {
              //  self.addBoxes()
            //}
        })
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        print("removed new accessory?")
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
    
    func addBoxes(){
        let gap = 20
        let deviceArraySize = accessories.count
        
        // Width of module = 200, width of gap = 20 * the amount of devices
        let widthOfContainer = 220*deviceArraySize
        horizontalDeviceModuleWidth.constant = CGFloat(widthOfContainer)
        self.view.layoutIfNeeded()
        
        for j in 0...deviceArraySize-1 {
            // 16 is our offset
            let newX = (j * 200) + (j * gap) + 16
            let newDevModule: ERDeviceModule = ERDeviceModule.instanceOfNib(deviceName: accessories[j].name, energyConsumptionPerHour: 69.69)
            newDevModule.frame = CGRect(x: newX, y: 0, width: 200, height: 144)
            horizontalDeviceModuleContainerView.addSubview(newDevModule)
        }
    }
    
    func animateText() {
        
    }
    
    func testHomeKit(){
        if let home = homeManager.primaryHome {
            print("testing home and \(home.accessories.count)")
            accessories = home.accessories
            addBoxes()
            
            let lightServices = home.servicesWithTypes([HMServiceTypeLightbulb])! as [HMService]
            for service in lightServices {
                let on = service.characteristics[1].value!
                let intensity = service.characteristics[2].value!
                print("This light is: \(on) at level \(intensity)%")
            }
        }else{
            self.homeManager.addHome(withName: "UserHome", completionHandler: { (home, error) in
                if error != nil {
                    print("Something went wrong when attempting to create our home. \(error?.localizedDescription)")
                } else {
                    self.homeManager.updatePrimaryHome(self.homeManager.homes[0], completionHandler: {(error) in
                        if error != nil {
                            print("Update primary home Error \(error?.localizedDescription)")
                        } else {
                            print(self.homeManager.homes)
                            self.browser.startSearchingForNewAccessories()
                            Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(ERMainViewController.stopSearching), userInfo: nil, repeats: false)
                        }
                    })
                }
            })
        }
    }
}
