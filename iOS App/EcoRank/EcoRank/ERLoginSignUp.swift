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
        let requestURL = "https://ecorank.xsanda.me/login"
        let postString = "username=\(username)&password=\(password)"
        triggerPOSTRequestWith(reqUrl: requestURL, params: postString, viewController: viewController)
    }
    
    class func signUpWith(username: String, password:String, long: Double, lat: Double, viewController: UIViewController){
        let requestURL = "https://ecorank.xsanda.me/users"
        let postString = "username=\(username)&password=\(password)&long=\(long)&lat=\(lat)"
        triggerPOSTRequestWith(reqUrl: requestURL, params: postString, viewController: viewController)
    }
    
    class func loginWith(userId: Int, authToken: String, viewController: UIViewController){
        let requestURL = "https://ecorank.xsanda.me/test"
        triggerGETRequestWith(reqUrl: requestURL, userId: userId, authToken: authToken, viewController: viewController)
    }
    
    class func triggerGETRequestWith(reqUrl: String, userId: Int, authToken: String, viewController: UIViewController){
        var request = URLRequest(url: URL(string: reqUrl)!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        print("Trying to Auto-Login..")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
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
                
                let responseArr: [String: Any] = ERUtilities.dataToJSON(data: data) as! [String: Any]
                print(responseArr["errorCode"] as! Int)
                
                ERUtilities.displayErrorToUserWith(userCode: responseArr["errorCode"] as! Int, viewController: viewController)
                
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
            print("Auto-Login Status: \(responseString!)")
            
            if responseString == "true"{
                print("Loading main screen")
                NotificationCenter.default.post(name:Notification.Name(rawValue:"successfulLogin"), object: nil, userInfo: nil)
            }
        }
        task.resume()
    }
    
    class func triggerPOSTRequestWith(reqUrl: String, params: String, viewController: UIViewController){
        var request = URLRequest(url: URL(string: reqUrl)!)
        request.httpMethod = "POST"
        
        request.httpBody = params.data(using: .utf8)
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
                
                let responseArr: [String: Any] = ERUtilities.dataToJSON(data: data) as! [String: Any]
                print(responseArr["errorCode"] as! Int)
                
                ERUtilities.displayErrorToUserWith(userCode: responseArr["errorCode"] as! Int, viewController: viewController)
                
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
            print("response (good response) = \(responseString!)")
            
            // We know we have a successful login at this point so can extract the auth token
            extractAndStoreAuthTokenAndUserIdFrom(responseData: data)
            
            print("Loading main screen")
            NotificationCenter.default.post(name:Notification.Name(rawValue:"successfulLogin"), object: nil, userInfo: ["response":responseString!])
        }
        task.resume()
    }
    
    // When we have a successful login we are passed the auth token and we have to extract and save it
    class func extractAndStoreAuthTokenAndUserIdFrom(responseData: Data){
        let responseArr: [String : Any] = ERUtilities.dataToJSON(data: responseData) as! [String : Any]
        print("Auth Token: \(responseArr["token"]!)")
        UserDefaults.standard.set(responseArr["token"]!, forKey: "authToken")
        print("User ID: \(responseArr["userId"]!)")
        UserDefaults.standard.set(responseArr["userId"]!, forKey: "userId")
    }
}
