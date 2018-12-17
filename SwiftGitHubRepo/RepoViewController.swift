//
//  RepoViewController.swift
//  SwiftGitHubRepo
//
//  Created by Clayton on 17/12/18.
//  Copyright © 2018 claytoglive. All rights reserved.
//

import UIKit



class RepoViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var repoTableView: UITableView!
    
    var repoToken :String!
    
    var repoList: [String]! = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoTableCell", for: indexPath)
        
        cell.textLabel?.text = repoList[indexPath.row]
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        repoTableView.delegate = self
        repoTableView.dataSource = self
        
        navBar.topItem?.title = "Repos for Token: " + repoToken
        
        
        parseGitRepo()
        
        repoTableView.reloadData()
    }
    
    func parseGitRepo(){
        
        do {
            
            /*
                Encountered issue with permissions, so sample JSON data is passed.
             */
            
            let path = Bundle.main.path(forResource: "sample", ofType: "json")
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
            
            let json = try JSONSerialization.jsonObject(with: data as Data, options:.allowFragments) as! [String:AnyObject]

            var x = 0
            
            for _ in json["items"] as? [[String: Any]] ?? [] {
                
                guard let item = json["items"] as? [[String: Any]] else {
                    // Handle error here
                    return
                }
            
                if let nameString = item[x]["name"]! as? String {
                    repoList.append(nameString)
                }
                x = x + 1
            }
            

           
        }
        catch {
            print("Error: No data")
        }
        
       
        
    }
    

}
