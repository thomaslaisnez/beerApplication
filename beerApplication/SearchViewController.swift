//
//  SearchViewController.swift
//  beerApplication
//
//  Created by Thomas Laisnez on 13/01/17.
//  Copyright © 2017 Thomas Laisnez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var category: UIPickerView!
    
    var categories: [String] = []
    var selectedCategory: String = ""
    
    var beers: [String] = []
    var ids: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        beers.removeAll()
        ids.removeAll()
        
        category.dataSource = self
        category.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        
        //getDataFromDatabase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
//    func getDataFromDatabase() {
//        Alamofire.request("https://api.brewerydb.com/v2/beer/oeGSxs?key=e1fd665a365668c993581f17cbd0358e&format=json").responseJSON {
//            (response) -> Void in
//            
//            if let value = response.result.value {
//                let jsonBeer = JSON(value)
//                
//                print("start")
//                print(jsonBeer["data"]["name"].stringValue)
//                print("did this work")
//            }
//        }
//    }
    
    func doGetQuery(queryString: String) {
        
        let newSearchQuery = queryString.replacingOccurrences(of: " ", with: "%20")
        print(newSearchQuery)
        Alamofire.request("https://api.brewerydb.com/v2/search?q=" + newSearchQuery + "&type=beer&p=1&key=e1fd665a365668c993581f17cbd0358e&format=json").responseJSON {
            (response) -> Void in
            
            if let value = response.result.value {
                let jsonBeer = JSON(value)
                
                for i in 0...11 {
                    if(!jsonBeer["data"][i]["name"].stringValue.isEmpty){
                        //print(jsonBeer["data"][i]["name"].stringValue)
                        self.ids.append(jsonBeer["data"][i]["id"].stringValue)
                        self.beers.append(jsonBeer["data"][i]["name"].stringValue)
                        //print(self.categories)
                    }
                    //print(jsonBeer["data"][i]["name"].stringValue)
                }
                //print(jsonBeer["data"]["name"].stringValue)
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "textSearch"){
            doGetQuery(queryString: text.text!)
            let destination = segue.destination as! SearchResultViewController
            
            //print("this is the given text")
            //destination.searchQuery = text.text
            //print(text.text!)
            destination.beers.removeAll()
            destination.beers = self.beers
            destination.ids.removeAll()
            destination.ids = self.beers
            //destination.viewDidLoad()
        }
        if(segue.identifier == "categorySearch"){
            doGetQuery(queryString: selectedCategory)
            let destination = segue.destination as! SearchResultViewController
            
            //print("this is the given category")
            //destination.searchQuery = selectedCategory
            //print(selectedCategory)
            destination.beers = self.beers
            destination.ids = self.beers
            //destination.viewDidLoad()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
    }
}
