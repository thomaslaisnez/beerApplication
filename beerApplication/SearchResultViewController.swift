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
    
    var searchQuery : String?
    var beers: [String] = []
    var ids: [String] = []

    override func viewDidLoad() {
        //super.viewDidLoad()
        
        //print(searchQuery!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        print(searchQuery!)
        getResultFromQuery(queryString: searchQuery!)
        //print(beers)
    }
    
    func getResultFromQuery(queryString: String) {
        
        let newSearchQuery = queryString.replacingOccurrences(of: " ", with: "%20")
        print(newSearchQuery)
        Alamofire.request("https://api.brewerydb.com/v2/search?q=" + newSearchQuery + "&type=beer&p=1&key=e1fd665a365668c993581f17cbd0358e&format=json").responseJSON {
            (response) -> Void in
            
            if let value = response.result.value {
                let jsonBeer = JSON(value)
                
                for i in 0...49 {
                    if(!jsonBeer["data"][i]["name"].stringValue.isEmpty){
                        //print(jsonBeer["data"][i]["name"].stringValue)
                        self.ids.append(jsonBeer["data"][i]["id"].stringValue)
                        self.beers.append(jsonBeer["data"][i]["name"].stringValue)
                        print(self.beers)
                    }
                    //print(jsonBeer["data"][i]["name"].stringValue)
                }
                //print(jsonBeer["data"]["name"].stringValue)
                
            }
            //print("does this run")
            self.searchResultsTableView.reloadData()
            //print("test")
        }
        
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
