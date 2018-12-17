//
//  ViewController.swift
//  SwiftGitHubRepo
//
//  Created by Clayton on 16/12/18.
//  Copyright © 2018 claytoglive. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    @IBOutlet weak var cookieLabel: UILabel!
    var authSession: ASWebAuthenticationSession?
    
    var userJSON : [String : Any]!
    var repoJSON : [[String : Any]]!
    
    var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func getUserAuth(_ sender: Any) {
        
        startIndicator()
        
        let authURL = URL(string: "https://github.com/login/oauth/authorize?client_id=9b14b73a97627c7e9de3")
        
        let callback  = "SwiftGitHubRepo://"

        //Initialize auth session
        self.authSession = ASWebAuthenticationSession(url: authURL!, callbackURLScheme: callback, completionHandler: { (callBack:URL?, error:Error? ) in
            guard error == nil, let successURL = callBack else {
                print(error!)
                self.cookieLabel.text = "Error retrieving token"
                return
            }
            
            var authCode = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            
        //    print(authCode ?? "No OAuth Token")
            
            let code = (authCode?.value)!
     
            self.getAccessToken(codeString: code)
            
        })
        cookieLabel.text = "Starting ASWebAuthenticationSession"
        self.authSession?.start()
    
    }
    
    
    
    func getAccessToken(codeString: String){
        
        let url : String = "https://github.com/login/oauth/access_token?client_id=9b14b73a97627c7e9de3&client_secret=965e0715a5ba3a4060dbd4b8e086877f968e4a2a&code="+codeString

        let headers = [
            "Accept" : "application/json"
        ]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
            //    print(json)

                guard let accessToken = json["access_token"] as? String else {
                    // Handle error here
                    return
                }
    
            //    print(accessToken )
                
                self.accessAPIUser(accessTokenString: accessToken)

                
            } catch {
                print("JSON Serialization error")
            }
            
            
        }).resume()
        
        
        
    }
    
    
    func accessAPIUser(accessTokenString: String){
        
        
        let url : String = "https://api.github.com/user?access_token="+accessTokenString
        
        let headers = [
            "Content-Type" : "application/json",
            "Accept" : "application/json"
        ]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                
                 let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                
                self.setUserJSON(jsonObj: json)
                
                self.accessAPIRepo(accessTokenString: accessTokenString)
                
            } catch {
                print("JSON Serialization error")
            }
            
            
        }).resume()
        
    }
    
    func accessAPIRepo(accessTokenString: String){
        
        
        let url : String = "https://api.github.com/user/repos?access_token="+accessTokenString
        
        let headers = [
            "Content-Type" : "application/json",
            "Accept" : "application/json"
        ]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String:AnyObject]]
                
           //     print(json)
                
                self.setRepoJSON(jsonObj: json)
            
                
            } catch {
                print("JSON Serialization error")
            }
            
            
        }).resume()
        
    }
    
    
    
    
    func setUserJSON(jsonObj : [String : Any]){
        
        self.userJSON = jsonObj
        
    }
    
    func setRepoJSON(jsonObj : [[String : Any]]){
        
        self.repoJSON = jsonObj
        
        self.performSegue(withIdentifier: "repoSegue", sender: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "repoSegue") {
            // pass data to next view
            if let destinationViewController = segue.destination as? RepoViewController {
                
                destinationViewController.userJSON = self.userJSON
                destinationViewController.repoJSON = self.repoJSON

                
            }
        }
        
        
    }
    
    
func startIndicator() {
        
        
        //Create Activity Indicator
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.transform = CGAffineTransform(scaleX: 2.0, y: 2.0);
        activityIndicator.center = CGPoint(x: view.center.x - 0, y: view.center.y + 40)
        activityIndicator.hidesWhenStopped = true // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        
        activityIndicator.startAnimating() // Start Activity Indicator
        view.addSubview(activityIndicator)
        self.view.bringSubviewToFront(activityIndicator)
    
    }
    
    
}
