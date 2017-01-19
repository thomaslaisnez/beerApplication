//
//  SavedViewController.swift
//  beerApplication
//
//  Created by Thomas Laisnez on 19/01/17.
//  Copyright © 2017 Thomas Laisnez. All rights reserved.
//

import UIKit
import RealmSwift

class SavedViewController: UITableViewController {
    
    @IBOutlet var myBeersTableView: UITableView!
    
    var beers: [Beer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBeersFromDB()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //print(beers[0].name)
    }
    
    @IBAction func unwindToSavedBeers(segue: UIStoryboardSegue) {}
    
    func getBeersFromDB() {
        //DispatchQueue(label: "background").async {
            let realm = try! Realm()
            self.beers = Array(realm.objects(Beer.self))
        //}
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
        
        cell.cellLabel.text = beers[indexPath.item].name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        let index = myBeersTableView.indexPathsForSelectedRows!.first!.row
        print(beers[index].name)
        destination.beer = beers[index]
        //destination.navigationItem.rightBarButtonItem?.isEnabled = false
        //destination.navigationItem.rightBarButtonItem?.title = "-"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBeersFromDB()
        self.myBeersTableView.reloadData()
    }

}
