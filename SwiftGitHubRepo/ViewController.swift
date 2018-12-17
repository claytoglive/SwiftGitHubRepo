//
//  ViewController.swift
//  SwiftGitHubRepo
//
//  Created by Clayton on 16/12/18.
//  Copyright © 2018 claytoglive. All rights reserved.
//

import UIKit
import AuthenticationServices

var oauthToken: URLQueryItem!

func getQueryStringParameter(url: String, param: String) -> String? {
    guard let url = URLComponents(string: url) else { return nil }
    return url.queryItems?.first(where: { $0.name == param })?.value
}

class ViewController: UIViewController {
    
    @IBOutlet weak var cookieLabel: UILabel!
    var authSession: ASWebAuthenticationSession?
    
    let cookiename = "expiry-fix-test"
    
    @IBAction func getUserAuth(_ sender: Any) {
        
        let authURL = URL(string: "https://github.com/login/oauth/authorize?client_id=9b14b73a97627c7e9de3")
        
        let callback  = "SwiftGitHubRepo://"

        //Initialize auth session
        self.authSession = ASWebAuthenticationSession(url: authURL!, callbackURLScheme: callback, completionHandler: { (callBack:URL?, error:Error? ) in
            guard error == nil, let successURL = callBack else {
                print(error!)
                self.cookieLabel.text = "Error retrieving token"
                return
            }
            
            oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first
            
            print(oauthToken ?? "No OAuth Token")
            
            let tokenStr = "token " + (oauthToken?.value)!
     
            print (tokenStr)

            let url : String = "https://api.github.com/user/repos"
            
            let headers = [
            "Authorization": tokenStr,
            "Content-Type" : "application/json",
            "Accept" : "application/json"
            ]
             
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
         
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
   
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                    print(json)
                    
                    self.performSegue(withIdentifier: "repoSegue", sender: nil)
   
                } catch {
                    print("JSON Serialization error")
                }
                
               
            }).resume()
            
        
            
        })
        cookieLabel.text = "Starting ASWebAuthenticationSession"
        self.authSession?.start()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "repoSegue") {
            // pass data to next view
            if let destinationViewController = segue.destination as? RepoViewController {
                
              destinationViewController.repoToken = (oauthToken?.value)!

                
            }
        }
        
        
    }
    
    
    
}
