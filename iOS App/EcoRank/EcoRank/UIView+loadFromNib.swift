//
//  UIView+loadFromNib.swift
//  EcoRank
//
//  Created by Brendon Warwick on 27/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func loadFromNib(named: String, bundle: Bundle? = nil) -> UIView?{
        
        return UINib(
            nibName: named,
            bundle: bundle
        ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
