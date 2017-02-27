//
//  ERLoginForm.swift
//  EcoRank
//
//  Created by Brendon Warwick on 27/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import Foundation
import UIKit

class ERLoginForm : UIView {
    
    class func instanceFromNib() -> ERLoginForm {
        return UINib(nibName: "ERLoginForm", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ERLoginForm
    }
}
