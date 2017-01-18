//
//  SearchResultViewControllerTableViewController.swift
//  beerApplication
//
//  Created by Thomas Laisnez on 16/01/17.
//  Copyright © 2017 Thomas Laisnez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchResultViewController: UITableViewController {
    
    @IBOutlet var searchResultsTableView: UITableView!
    
    //var searchQuery : String?
    var beers: [String] = []
    var ids: [String] = []

    override func viewDidLoad() {
        //super.viewDidLoad()
        
        //print(searchQuery!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        beers.append("Vedett")
        beers.append("Duvel")
        ids.append("1")
        ids.append("2")
        //print(beers)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath) as! BeerCellView
        
        cell.cellLabel.text = beers[indexPath.item]
        
        return cell
    }

    
}
