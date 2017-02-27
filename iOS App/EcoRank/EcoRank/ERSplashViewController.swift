//
//  ViewController.swift
//  EcoRank
//
//  Created by Brendon Warwick on 25/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import UIKit
import CoreLocation

class ERSplashViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var grassHillView: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var createNewAccountButton: UIButton!
    @IBOutlet weak var getLocationButton: UIButton!
    @IBOutlet weak var quitButton: UIButton!

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var loginUsernameTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var signupUsernameTextField: UITextField!
    @IBOutlet weak var signupPasswordTextField: UITextField!

    @IBOutlet weak var greenHillBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!

    var userLat = 0.0
    var userLong = 0.0
    let locationManager = CLLocationManager()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView(){
        self.view.backgroundColor = ERSkyBlue
        loginView.isHidden = true
        locationView.isHidden = true
        quitButton.alpha = 0
        loginView.backgroundColor = UIColor.clear
        grassHillView.backgroundColor = ERGreen
        logoLabel.font = UIFont(name: "Montserrat-Medium", size: 40)
        logoLabel.textColor = UIColor.white
        logoLabel.textAlignment = .center
        loginButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 24)
        signUpButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 20)
        // Adds padding to our textfields
        loginUsernameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        loginPasswordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        createNewAccountButton.isEnabled = false
    }
    
    //MARK: Location Handler
    func setLocationGraphic(){
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: userLat, longitude: userLong)
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks in
            let array = placemarks.0
            if let placemark = array?[0] {
                self.locationLabel.text = placemark.locality
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.locationView.isHidden = false
                self.getLocationButton.isHidden = true
                self.view.layoutIfNeeded()
            })
        })

    }
    

    //MARK: Button Actions
    @IBAction func userTouchedLoginButton(_ sender: Any) {
        moveHill(createNewUser: false)
    }
    
    @IBAction func quitButtonTouched(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.loginView.alpha = 0
            self.locationView.alpha = 0
            self.signUpView.alpha = 0
            self.quitButton.alpha = 0
            self.view.layoutIfNeeded()

        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.75, animations: {
                self.greenHillBottomConstraint.constant += 220
                self.titleTopConstraint.constant += 50
                self.view.layoutIfNeeded()
            })
        })
    }

    @IBAction func userTouchedSignUpButton(_ sender: Any) {
        moveHill(createNewUser: true)
    }

    @IBAction func userTouchedSubmitButton(_ sender: Any) {
        if !loginUsernameTextField.text!.contains("&"){
            postLoginDetails(username: loginUsernameTextField.text!, password: loginPasswordTextField.text!)
        }else{
            loginUsernameTextField.text = ""
            loginPasswordTextField.text = ""

            let alertController = UIAlertController(title: "Illegal Character in Username", message: "Please use standard characters (excluding &, =, etc) in your username.", preferredStyle: .alert)

            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        }
    }

    @IBAction func userTouchedGetLocation(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
            userLat = locValue.latitude
            userLong = locValue.longitude
            createNewAccountButton.isEnabled = true
            setLocationGraphic()
            
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this app in Settings.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            present(alert, animated: true, completion: nil)
            alert.addAction(okAction)
        }
    }

    @IBAction func userConfirmedCreateNewAccount(_ sender: Any) {
        var request = URLRequest(url: URL(string: "https://ecorank.xsanda.me/users")!)
        request.httpMethod = "POST"

        let username = signupUsernameTextField.text!
        let password = signupPasswordTextField.text!

        let postString = "username=\(username)&password=\(password)&long=\(userLong)&lat=\(userLat)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for fundamental networking error
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }

            // Check for HTTP errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("Response = \(response)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")

            print("Loading main screen")
            self.successfulLogin(response: responseString!)

        }
        task.resume()
    }

    // MARK: HTTP Requests
    func postLoginDetails(username: String, password: String){
        var request = URLRequest(url: URL(string: "https://ecorank.xsanda.me/login")!)
        request.httpMethod = "POST"
        let postString = "username=\(username)&password=\(password)"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for fundamental networking error
            guard let data = data, error == nil else {
                print("error=\(error)")
                return
            }

            // Check for HTTP errors
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("Response = \(response)")
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                
                return
            }

            //let trialResult = self.dataToJSON(data: data)
            //print("JSON:" + "\(trialResult)")

            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")

            //if responseString == "hi" {
                // Load Main screen
                print("Loading main screen")
                self.successfulLogin(response: responseString!)
            //}
        }
        task.resume()
    }

    func successfulLogin(response: String){
        DispatchQueue.main.async {
            let localUser = ERUser.init(id: 1, username: "brendon", longitude: 0.444533432, latitude: -0.32542352, houseClassifier: 2)
            print("\(localUser.username) logged in")

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ERMainViewController") as! ERMainViewController
            self.present(vc, animated: false, completion: nil)
        }
    }

    //MARK: JSON Parser
    func dataToJSON(data: Data) -> Any? {
        do {
            let JSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            return JSON
        } catch let error as NSError {
            print("Error whilst trying to parse JSON: \(error.userInfo)")
        }
        return nil
    }

    //MARK: Animation Handlers
    func moveHill(createNewUser: Bool){
        UIView.animate(withDuration: 0.75, animations: {
            self.greenHillBottomConstraint.constant -= 220
            self.titleTopConstraint.constant -= 50
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
             self.presentUserInput(createNewUser: createNewUser)
        })
    }

    func presentUserInput(createNewUser: Bool){
        if !createNewUser {
            self.loginView.isHidden = false
            self.loginView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
            self.loginView.alpha = 1.0
            self.quitButton.alpha = 1
            })
        } else {
            self.signUpView.isHidden = false
            self.signUpView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.signUpView.alpha = 1.0
                self.quitButton.alpha = 1
            })
                
        }
        
    }
    
    //MARK: Gesture Handlers
    @IBAction func tapGestureHandler(_ sender: UITapGestureRecognizer) {
        if loginPasswordTextField.isFirstResponder || loginUsernameTextField.isFirstResponder || signupPasswordTextField.isFirstResponder || signupUsernameTextField.isFirstResponder {
            print("hi")
            loginPasswordTextField.resignFirstResponder()
            loginUsernameTextField.resignFirstResponder()
            signupPasswordTextField.resignFirstResponder()
            signupUsernameTextField.resignFirstResponder()
        }
    }
}
