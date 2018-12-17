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
    
    
    var userJSON : [String : Any]!
    var repoJSON : [[String : Any]]!
    
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
        
        parseUserJSON()

        parseRepoJSON()
        
        repoTableView.reloadData()
    }
    
    
    func parseUserJSON(){
        
        let nameString = self.userJSON["login"]! as? String
        
        navBar.topItem?.title = "Repos for user: " + nameString!
        
    }
    
    func parseRepoJSON(){
        
            var x = 0

            for _ in self.repoJSON  {
                
                if let nameString = self.repoJSON[x]["name"]! as? String {
                    repoList.append(nameString)
                }

                x = x + 1
            }

        }
    

}
