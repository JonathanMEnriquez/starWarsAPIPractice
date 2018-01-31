//
//  MoviesTableViewController.swift
//  starWarsAPI
//
//  Created by user on 1/30/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

protocol MoviesTableViewControllerDelegate {
    func getStarWars(urlToUse: String, delegateFunction: Bool)
}

class MoviesTableViewController: UITableViewController {

    var delegate: MoviesTableViewControllerDelegate?
    var films = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("call delegate")
        delegate?.getStarWars(urlToUse: "https://swapi.co/api/films/", delegateFunction: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return films.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = films[indexPath.row].object(forKey: "title")! as! String
        return cell
    }
}
