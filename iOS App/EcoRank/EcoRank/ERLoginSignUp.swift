//
//  ERLoginSignUp.swift
//  EcoRank
//
//  Created by Brendon Warwick on 28/02/2017.
//  Copyright © 2017 EcoRank. All rights reserved.
//

import Foundation
import UIKit

class ERLoginSignUp {
    
    class func loginWith(username: String, password: String, viewController: UIViewController){
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
                
                let responseString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
                print("response (bad response) = \(responseString!))")
                
                let responseArr: [String : Any] = ERUtilities.dataToJSON(data: data) as! [String : Any]
                print(responseArr["errorCode"] as! Int)
                
                ERUtilities.displayErrorToUserWith(userCode: responseArr["errorCode"] as! Int, viewController: viewController)
                
                return
            }
            
            //let trialResult = self.dataToJSON(data: data)
            //print("JSON:" + "\(trialResult)")
            
            let responseString = String(data: data, encoding: .utf8)
            print("response (good response) = \(responseString!.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)))")
            
            //if responseString == "hi" {
            // Load Main screen
            print("Loading main screen")
            
            // NSNOTIFICATION!
            //self.successfulLogin(response: responseString!)
            
            //}
        }
        task.resume()
    }
    
    class func signUpWith(username: String, password:String, long: Double, lat: Double, viewController: UIViewController){
        var request = URLRequest(url: URL(string: "https://ecorank.xsanda.me/users")!)
        request.httpMethod = "POST"
        
        let postString = "username=\(username)&password=\(password)&long=\(long)&lat=\(lat)"
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
                
                let responseString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
                print("response (bad response) = \(responseString!))")
                
                let responseArr: [String : Any] = ERUtilities.dataToJSON(data: data) as! [String : Any]
                print(responseArr["errorCode"] as! Int)
                
                ERUtilities.displayErrorToUserWith(userCode: responseArr["errorCode"] as! Int, viewController: viewController)
                
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString!.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)))")
            
            print("Loading main screen")
            //self.successfulLogin(response: responseString!)
            
        }
        task.resume()
    }
}
