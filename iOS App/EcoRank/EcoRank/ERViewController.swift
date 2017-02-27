//
//  ViewController.swift
//  EcoRank
//
//  Created by Brendon Warwick on 25/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import UIKit

class ERViewController: UIViewController {
    
    @IBOutlet weak var grassHillView: UIView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginView: ERLoginForm!
    
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
        grassHillView.backgroundColor = ERGreen
        logoLabel.font = UIFont(name: "Montserrat-Medium", size: 40)
        logoLabel.textColor = UIColor.white
        logoLabel.textAlignment = .center
        loginButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 28)
        signUpButton.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 20)
    }

    @IBAction func userTouchedLoginButton(_ sender: Any) {
        //let vc = self.storyboard?.instantiateViewController(withIdentifier: "ERLoginViewController") as! ERViewController
        moveHill()
        //self.present(vc, animated: false, completion: nil)
        self.loginView.alpha = 0
        self.loginView.addSubview(ERLoginForm.instanceFromNib())
        UIView.animate(withDuration: 1.52, animations: {
            self.loginView.alpha = 1.0
        })
    }

    func moveHill(){
        UIView.animate(withDuration: 1.52, animations: {
            self.greenHillBottomConstraint.constant -= 220
            self.titleTopConstraint.constant -= 50
            self.view.layoutIfNeeded()
        })
    }
}

