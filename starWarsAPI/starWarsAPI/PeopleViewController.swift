//
//  ViewController.swift
//  starWarsAPI
//
//  Created by user on 1/28/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class PeopleViewController: UITableViewController {

    var people = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStarWars(urlToUse: "https://swapi.co/api/people/")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = (people[indexPath.row].object(forKey: "name")! as! String)
        return cell
    }
    
    func getStarWars(urlToUse: String){
        
        guard let url = URL(string: urlToUse) else {
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url, completionHandler: {
            data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    
                    if let results = jsonResult["results"] {
                        
                        let resultsArr = results as! NSArray
                        for result in resultsArr {
                            self.people.append(result as! NSDictionary)
                            print(self.people.count)
                            print(result)
                        }
                    }
                    if let next = jsonResult["next"] {
                        self.getStarWars(urlToUse: String(describing: next))
                    }
                    else {
                        return
                    }
                }
            } catch {
                print(error)
            }
        })
        
        task.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            print(self.people.count)
            self.tableView.reloadData()
        }
    }
}

