//
//  ViewController.swift
//  EcoRank
//
//  Created by Brendon Warwick on 25/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var grassHillView: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(){
        self.view.backgroundColor = ERSkyBlue
        grassHillView.backgroundColor = ERGreen
        logoLabel.font = UIFont(name: "Montserrat-Medium", size: 40)
        logoLabel.textColor = UIColor.white
        logoLabel.textAlignment = .center
        loginButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 28)
        signUpButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 20)
    }

    @IBAction func userTouchedLoginButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
        self.present(vc, animated: false, completion: nil)
    }
    

}

