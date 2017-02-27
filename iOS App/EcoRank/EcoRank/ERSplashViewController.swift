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
        loginButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 28)
        signUpButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 20)
    }

    
    //MARK: Button Actions
    @IBAction func userTouchedLoginButton(_ sender: Any) {
        moveHill()
    }

    @IBAction func userTouchedSubmitButton(_ sender: Any) {
        //TODO: Validate user input
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ERMainViewController") as! ERMainViewController
        self.present(vc, animated: false, completion: nil)
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

