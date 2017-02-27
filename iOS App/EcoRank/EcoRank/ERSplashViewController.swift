//
//  ViewController.swift
//  EcoRank
//
//  Created by Brendon Warwick on 25/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import UIKit

class ERSplashViewController: UIViewController {
    
    @IBOutlet weak var grassHillView: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginUsernameTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var greenHillBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(){
        self.view.backgroundColor = ERSkyBlue
        self.loginView.isHidden = true
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
    }
    
    //MARK: Button Actions
    @IBAction func userTouchedLoginButton(_ sender: Any) {
        moveHill()
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
                return
            }
            
            //let trialResult = self.dataToJSON(data: data)
            //print("JSON:" + "\(trialResult)")
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
            if responseString == "hi" {
                // Load Main screen
                print("Loading main screen")
                self.successfulLogin(response: responseString!)
            }
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
    func moveHill(){
        UIView.animate(withDuration: 0.75, animations: {
            self.greenHillBottomConstraint.constant -= 220
            self.titleTopConstraint.constant -= 50
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
             self.presentUserInput()
        })
    }
    
    func presentUserInput(){
        self.loginView.isHidden = false
        self.loginView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.loginView.alpha = 1.0
        })
    }
}

