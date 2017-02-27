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
    
    override func viewWillAppear(_ animated: Bool) {
        // Beginning value for constraint so the cloud is off the screen
        cloudTopConstraint.constant = -148
    }
    override func viewDidAppear(_ animated: Bool) {
        animateClouds()
        self.view.backgroundColor = ERSkyBlue
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
    
    
    func animateText() {
        
    }
}
