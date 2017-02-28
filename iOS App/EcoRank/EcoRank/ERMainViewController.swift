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
    
    override func viewWillAppear(_ animated: Bool) {
        // Beginning value for constraint so the cloud is off the screen
        cloudTopConstraint.constant = -148
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateClouds()
        self.view.backgroundColor = ERSkyBlue
        self.horizontalDeviceModuleParentView.backgroundColor = UIColor.clear
        addTestBoxes()
        
        
        //HomeKit
        homeManager.delegate = self
        browser.delegate = self
        testHomeKit()
    }
    
    //MARK: Accessory delegate methods
    
    func stopSearching(){
        print("stopping searchign for acc")
        browser.stopSearchingForNewAccessories()
        print(accessories)
        manageAccessories()
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        accessories.append(accessory)
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
        print(homeManager.homes)
        if let home = homeManager.primaryHome {
            print("found a home")
            for room in home.rooms {
                print("found a room")
                for accessory in room.accessories {
                    print("Name : \(accessory.name), UUID \(accessory.uniqueIdentifier)")
                }
            }
        }else{
            self.homeManager.addHome(withName: "Porter Ave", completionHandler: { (home, error) in
                if error != nil {
                    print("Something went wrong when attempting to create our home. \(error?.localizedDescription)")
                } else {
                    self.homeManager.updatePrimaryHome(self.homeManager.homes[0], completionHandler: {(error) in
                        if error != nil {
                            print("Update primary home Error \(error?.localizedDescription)")
                        } else
                            if let discoveredHome = home {
                            // Add a new room to our home
                                discoveredHome.addRoom(withName: "Office", completionHandler: { (room, error) in
                                    if error != nil {
                                        print("Something went wrong when attempting to create our room. \(error?.localizedDescription)")
                                    }})
                                self.homeManager.updatePrimaryHome(discoveredHome, completionHandler: { (error) in
                                    if error != nil {
                                        print("Something went wrong when attempting to make this home our primary home. \(error?.localizedDescription)")
                            }
                                })
                                print(self.homeManager.homes)
                                self.browser.startSearchingForNewAccessories()
                                Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(ERMainViewController.stopSearching), userInfo: nil, repeats: false)
                        }
                    })
                }
            })
            
        }
        
    }
    
    func manageAccessories(){
        let primaryHome = homeManager.primaryHome!
        for accessory in accessories {
            primaryHome.addAccessory(accessory, completionHandler: { error -> Void in
                if error != nil {
                    print("Error whilst trying to add accessory \(error?.localizedDescription)")
                }
            })
            primaryHome.assignAccessory(accessory, to: primaryHome.rooms[0], completionHandler: { error -> Void in
                if error != nil {
                    print("error whilst trying to assign accessory \(error?.localizedDescription)")
                }
            })
        }
    }
}
