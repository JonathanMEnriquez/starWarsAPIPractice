//
//  ViewController.swift
//  starWarsAPI
//
//  Created by user on 1/28/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class PeopleViewController: UITableViewController, MoviesTableViewControllerDelegate {

    var people = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStarWars(urlToUse: "https://swapi.co/api/people/", delegateFunction: false)
        
        let moviesVC = getOtherVC()
        moviesVC.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = (people[indexPath.row].object(forKey: "name")! as! String)
        return cell
    }
    
    func getStarWars(urlToUse: String, delegateFunction: Bool){
        
        var otherVC: MoviesTableViewController?
        guard let url = URL(string: urlToUse) else {
            return
        }
        
        if delegateFunction == false {
            let session = URLSession.shared
            
            let task = session.dataTask(with: url, completionHandler: {
                data, response, error in
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        if let results = jsonResult["results"] {
                            
                            let resultsArr = results as! NSArray
                            for result in resultsArr {
                                self.people.append(result as! NSDictionary)
                            }
                        }
                        if let next = jsonResult["next"] {
                            self.getStarWars(urlToUse: String(describing: next), delegateFunction: false)
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        else {
            print("went into else")
            let session = URLSession.shared
            otherVC = getOtherVC()
            let task = session.dataTask(with: url, completionHandler: {
                data, response, error in
                
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        
                        if let results = jsonResult["results"] {
                            
                            let resultsArr = results as! NSArray
                            for result in resultsArr {
                                otherVC?.films.append(result as! NSDictionary)
                            }
                        }
                        if let next = jsonResult["next"] {
                            self.getStarWars(urlToUse: String(describing: next), delegateFunction: true)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                print("reload")
                otherVC?.tableView.reloadData()
            })
        }
        
    }
    
    func getOtherVC() -> MoviesTableViewController {
        let moviesVC = tabBarController?.viewControllers![1] as! MoviesTableViewController
        return moviesVC
    }
}

