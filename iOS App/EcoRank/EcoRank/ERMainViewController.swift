//
//  ERLoginViewController.swift
//  EcoRank
//
//  Created by Jay Lees on 27/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import UIKit
import HomeKit

class ERMainViewController: UIViewController, HMHomeManagerDelegate, HMAccessoryBrowserDelegate, HMAccessoryDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cloudTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollContainerView: UIView!
    @IBOutlet weak var monitorMyLivingSwitch: UISwitch!
    
    @IBOutlet weak var deviceCountLabel: UILabel!
    @IBOutlet weak var horizontalDeviceModuleParentView: UIView!
    @IBOutlet weak var horizontalDeviceModuleScrollView: UIScrollView!
    @IBOutlet weak var horizontalDeviceModuleContainerView: UIView!
    @IBOutlet weak var horizontalDeviceModuleWidth: NSLayoutConstraint!
    @IBOutlet weak var leaderBoardTableView: UITableView!
    
    let homeManager = HMHomeManager()
    let browser = HMAccessoryBrowser()
    var accessories = [HMAccessory]()
    var accNumber = 0
    var globalUsersIDArray = [Int]()
    var globalTopUsersTracker = 0
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    var updateTimer: Timer?
    var allGlobalUsers: [ERUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add Background task reinstater
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        //Fetches all users
        fetchAllUsers()
        
        // Fetched all users for leaderboard
        NotificationCenter.default.addObserver(self, selector: #selector(updateLeaderBoard(notification:)), name: NSNotification.Name(rawValue: "fetchedAllUsers"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTopLeaderBoard(notification:)), name: NSNotification.Name(rawValue: "fetchedTopUsers"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
        if homeManager.primaryHome?.accessories.count != nil {
            deviceCountLabel.text = "\(homeManager.primaryHome!.accessories.count)"
        } else {
            deviceCountLabel.text = "0"
        }
        testHomeKit()
    }
    
    //MARK: Accessory delegate methods
    //TODO
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        self.accessories.append(accessory)
        let primaryHome = homeManager.primaryHome!
        for accessory in accessories {
            accessory.delegate = self
            primaryHome.addAccessory(accessory, completionHandler: { error -> Void in
                if error != nil {
                    print("Error whilst trying to add accessory \(error.debugDescription)")
                }
                self.browser.startSearchingForNewAccessories()
            })
        }
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
        self.browser.startSearchingForNewAccessories()
        for subview in horizontalDeviceModuleContainerView.subviews {
            subview.removeFromSuperview()
        }
        let gap = 20
        let deviceArraySize = homeManager.primaryHome!.accessories.count
        
        // Width of module = 200, width of gap = 20 * the amount of devices
        let widthOfContainer = 220*deviceArraySize
        horizontalDeviceModuleWidth.constant = CGFloat(widthOfContainer)
        self.view.layoutIfNeeded()
        
        for j in 0...deviceArraySize-1 {
            // 16 is our offset
            let newX = (j * 200) + (j * gap) + 16
            let name = homeManager.primaryHome!.accessories[j].name
            let newDevModule: ERDeviceModule = ERDeviceModule.instanceOfNib(deviceName: name, energyConsumptionPerHour: powerInfo[name] )
            newDevModule.frame = CGRect(x: newX, y: 0, width: 200, height: 144)
            horizontalDeviceModuleContainerView.addSubview(newDevModule)
        }
    }
    
    func animateText() {
        
    }
    
    func testHomeKit(){
        if let home = homeManager.primaryHome {
            accessories = home.accessories
            self.browser.startSearchingForNewAccessories()
            addBoxes()
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
                            //Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.processAccessories), userInfo: nil, repeats: false)
                        }
                    })
                }
            })
        }
    }
    

    @IBAction func monitorMyLivingSwitchChanged(_ sender: Any) {
        // Turned on
        if monitorMyLivingSwitch.isOn {
            updateTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(fetchStateOfAccessories), userInfo: nil, repeats: true)
            // Register background task
            registerBackgroundTask()
            
        }else{ // turned off
            updateTimer?.invalidate()
            updateTimer = nil
            if backgroundTask != UIBackgroundTaskInvalid {
                endBackgroundTask()
            }
        }
    }
    
    func fetchStateOfAccessories(){
        let lightServices = homeManager.primaryHome!.servicesWithTypes([HMServiceTypeLightbulb])! as [HMService]
        for service in lightServices {
            for char in service.characteristics {
                if !char.properties.contains(HMCharacteristicPropertySupportsEventNotification) {
                    continue
                } else {
                    char.enableNotification(true, completionHandler: {(error) -> Void in
                        if error != nil {
                            print("Enable notifcation error \(error.debugDescription)")
                        }
                    })
                }
            }
            let on = service.characteristics[1].value!
            let intensity = service.characteristics[2].value!
            let id = service.characteristics[0].value!
            print("This light is: \(on) at level \(intensity)%")
            print(id)
            let bulbDataAnalyser = ERLightDataAnalyzer.init(intensity: intensity as! Int, onState: on as! Bool, id: id as! String)
            bulbDataAnalyser.incrementEnergyUsedForDay()
            print(bulbDataAnalyser.generateData(obj: bulbDataAnalyser))
            
        }
        
        //Iterates through all thermostats
        let thermostatServices = homeManager.primaryHome!.servicesWithTypes([HMServiceTypeThermostat])! as [HMService]
        for service in thermostatServices {
            for char in service.characteristics {
                if !char.properties.contains(HMCharacteristicPropertySupportsEventNotification) {
                    continue
                } else {
                    char.enableNotification(true, completionHandler: {(error) -> Void in
                        if error != nil {
                            print("Enable notifcation error \(error.debugDescription)")
                        }
                    })
                }
            }
            let startTemp = service.characteristics[3].value!
            let endTemp = service.characteristics[4].value!
            let heating = service.characteristics[1].value!
            let id = service.characteristics[0].value!
            print("Start temp is: \(startTemp) going to \(endTemp). Heating value is \(heating)")
            
            let thermostatDataAnalyser = ERThermostatDataAnalyzer.init(startTemp: startTemp as! Float, endTemp: endTemp as! Float, onState: heating as! Int, id: id as! String)
            thermostatDataAnalyser.incrementEnergyUsedForDay()
        }
    }
    
    func endFetchingForTheDay(){
        if backgroundTask != UIBackgroundTaskInvalid {
            endBackgroundTask()
        }
    }
    
    func reinstateBackgroundTask() {
        if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
            registerBackgroundTask()
        }
    }
    
    // MARK: Background Task Delegate
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    //MARK: TableViewMethods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGlobalUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pointsCell", for: indexPath)
        let usernameLabel = cell.viewWithTag(69) as! UILabel
        let pointsLabel = cell.viewWithTag(70) as! UILabel
        usernameLabel.text = "\(allGlobalUsers[indexPath.row].username)"
        pointsLabel.text = "\(allGlobalUsers[indexPath.row].energyUsed)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Get all users 
    func fetchAllUsers(){
        if let authToken = UserDefaults.standard.object(forKey: "authToken"){
            ERLoginSignUp.getAllGlobalUsersWith(authToken: authToken as! String, viewController: self)
        }
    }
    
    func updateLeaderBoard(notification: NSNotification){
        globalTopUsersTracker = 0
        print("Updating leaderboards..")
        let jsonArray = ERUtilities.dataToJSON(data: notification.userInfo!["users"]! as! Data)!
        
        for i in 0...20 {
            let userInJson: [String: Any] = (jsonArray as! [Any])[i] as! [String : Any]
            let newUser = ERUser(id: userInJson["userId"] as! Int, energyUsed: userInJson["energyUsed"] as! Float)
            allGlobalUsers.append(newUser)
        }
        allGlobalUsers.sort(by: sortUsers)
        getUsernames()
    }
    
    func sortUsers(this: ERUser, that: ERUser) -> Bool {
        return this.energyUsed < that.energyUsed
    }
    
    func getUsernames(){
        globalTopUsersTracker = 0
        for element in allGlobalUsers {
            if element.userId == 75 {
                continue
            }
            let requestURL = "https://ecorank.xsanda.me/users/\(element.userId)"
            if let authToken = UserDefaults.standard.object(forKey: "authToken"){
                ERLoginSignUp.triggerGETRequestForTop20With(reqUrl: requestURL, authToken: authToken as! String, viewController: self)
            }
        }
    }
    
    func updateTopLeaderBoard(notification: NSNotification){
        let jsonArray = ERUtilities.dataToJSON(data: notification.userInfo!["users"]! as! Data)!
        let userInJson = jsonArray as! [String : Any]
        allGlobalUsers[globalTopUsersTracker].username = userInJson["username"] as! String
        globalTopUsersTracker += 1
        DispatchQueue.main.async(){
            self.leaderBoardTableView.reloadData()
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        let authToken = UserDefaults.standard.object(forKey: "authToken") as! String
        ERLoginSignUp.triggerPOSTLogOutRequestWith(reqUrl: "https://ecorank.xsanda.me/logout", authToken: authToken, viewController: self)
        UserDefaults.standard.removeObject(forKey: "authToken")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ERSplashViewController") as! ERSplashViewController
        self.present(vc, animated: false, completion: nil)
    }
}
