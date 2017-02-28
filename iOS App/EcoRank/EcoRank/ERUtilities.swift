//
//  ERUtilities.swift
//  EcoRank
//
//  Created by Brendon Warwick on 28/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import Foundation
import UIKit

class ERUtilities{

    class func displayErrorToUserWith(userCode: Int, viewController: UIViewController){
        switch userCode {
        case 2:
            ERUtilities.displayAlertViewWith(title: "No Username Provided", message: "Please enter a username.", viewController: viewController)
        case 3:
            ERUtilities.displayAlertViewWith(title: "No Password Provided", message: "Please enter a password.", viewController: viewController)
        case 4:
            ERUtilities.displayAlertViewWith(title: "Wrong Username or Password", message: "Please enter a correct username and password combination.", viewController: viewController)
        default:
            ERUtilities.displayAlertViewWith(title: "Error Occured", message: "Error Occured Logging in with status code \(userCode)", viewController: viewController)
        }
    }
    
    class func displayAlertViewWith(title: String, message: String, viewController: UIViewController){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            viewController.present(alert, animated: true, completion: nil)
            alert.addAction(okAction)
        }
    }
    
    //MARK: JSON Parser
    class func dataToJSON(data: Data) -> Any? {
        do {
            let JSON = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            return JSON
        } catch let error as NSError {
            print("Error whilst trying to parse JSON: \(error.userInfo)")
        }
        return nil
    }

}
