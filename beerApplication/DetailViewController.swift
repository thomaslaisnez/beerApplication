//
//  DetailViewController.swift
//  beerApplicatvar
//
//  Created by Thomas Laisnez on 18/01/17.
//  Copyright © 2017 Thomas Laisnez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
import RealmSwift

class DetailViewController: UIViewController {

    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var beerDescription: UITextView!
    @IBOutlet weak var beerCategory: UILabel!
    @IBOutlet weak var beerAlcoholPercentage: UILabel!
    @IBOutlet weak var beerOrganic: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var beerId: String = ""
    var beerURL: String = ""
    var long: Double = 0.0
    var lat: Double = 0.0
    var beer: Beer = Beer()
    var inDB: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!beerId.isEmpty){
            //print(beerId)
            getBeer()
            //makeBeerItem()
        }else{
            setBeer()
        }
        
        //print(beer)
        
        if(beerInDB() == true){
            inDB = true
            self.navigationItem.rightBarButtonItem?.title = "-"
        }else{
            inDB = false
        }
        
        //print(inDB)
    }
    
    func getBeer(){
        
        Alamofire.request("https://api.brewerydb.com/v2/beer/" + beerId + "?withBreweries=y&key=e1fd665a365668c993581f17cbd0358e&format=json").responseJSON {
            (response) -> Void in
            
            if let value = response.result.value {
                let jsonBeer = JSON(value)
                
                self.beerName.text = jsonBeer["data"]["name"].stringValue
                self.beerDescription.text = jsonBeer["data"]["style"]["description"].stringValue
                self.beerCategory.text = jsonBeer["data"]["style"]["category"]["name"].stringValue
                //self.beerAlcoholPercentage.text = jsonBeer["data"]["style"]["abvMax"].stringValue
                if(jsonBeer["data"]["style"]["abvMax"].stringValue.isEmpty){
                    self.beerAlcoholPercentage.text = "Unknown"
                }else{
                    self.beerAlcoholPercentage.text = jsonBeer["data"]["style"]["abvMax"].stringValue
                }
                if(jsonBeer["data"]["isOrganic"].stringValue == "Y"){
                    self.beerOrganic.text = "Yes"
                }else{
                    self.beerOrganic.text = "No"
                }
                if(!jsonBeer["data"]["labels"]["icon"].stringValue.isEmpty || jsonBeer["data"]["labels"]["icon"].stringValue.contains(".png")){
                    //print(jsonBeer["data"]["labels"]["icon"].stringValue)
                    //let url = URL(string: jsonBeer["data"]["labels"]["icon"].stringValue)
                    //let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    //self.beerImage.image = UIImage(data: data!)
                    self.beerURL = jsonBeer["data"]["labels"]["icon"].stringValue
                    let url = URL(string: self.beerURL)
                    
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        DispatchQueue.main.async {
                            self.beerImage.image = UIImage(data: data!)
                        }
                    }
                }
                
                self.lat = jsonBeer["data"]["breweries"][0]["locations"][0]["latitude"].doubleValue
                self.long = jsonBeer["data"]["breweries"][0]["locations"][0]["longitude"].doubleValue
                
                let beerLocation = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
                self.map.region = MKCoordinateRegion(center: beerLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                let pin = MKPointAnnotation()
                pin.coordinate = beerLocation
                self.map.addAnnotation(pin)
                
            }
        }

    }
    
    func setBeer(){
        self.beerName.text = beer.name
        self.beerDescription.text = beer.desc
        self.beerCategory.text = beer.category
        self.beerAlcoholPercentage.text = beer.alcoholPercentage
        self.beerOrganic.text = beer.organic
        if(!beer.imageURL.isEmpty || beer.imageURL.contains(".png")){
            //print(jsonBeer["data"]["labels"]["icon"].stringValue)
            //let url = URL(string: jsonBeer["data"]["labels"]["icon"].stringValue)
            //let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            //self.beerImage.image = UIImage(data: data!)
            self.beerURL = beer.imageURL
            let url = URL(string: self.beerURL)
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.beerImage.image = UIImage(data: data!)
                }
            }
        }
        self.lat = beer.breweryLatitude
        self.long = beer.breweryLongitude
        
        let beerLocation = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
        self.map.region = MKCoordinateRegion(center: beerLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        let pin = MKPointAnnotation()
        pin.coordinate = beerLocation
        self.map.addAnnotation(pin)

    }
    
    @IBAction func saveBeerToDB(){
        
        if(inDB == true){
            //let realm = try! Realm()
            //realm.delete(beer)
            do {
                let realm = try Realm()
                //print(realm.configuration.fileURL!.absoluteString)
                try realm.write {
                    realm.delete(self.beer)
                }
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
            if(self.beerId.isEmpty){
                self.performSegue(withIdentifier: "unwindToSaved", sender: self)
            }
            
        }else{
            makeBeerItem()
            
            do {
                let realm = try Realm()
                //print(realm.configuration.fileURL!.absoluteString)
                try realm.write {
                    realm.add(self.beer)
                }
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
    }
    
    func makeBeerItem(){
        self.beer.id = beerId
        self.beer.name = beerName.text!
        self.beer.desc = beerDescription.text!
        self.beer.category = beerCategory.text!
        self.beer.alcoholPercentage = beerAlcoholPercentage.text!
        self.beer.organic = beerOrganic.text!
        self.beer.imageURL = beerURL
        self.beer.breweryLatitude = lat
        self.beer.breweryLongitude = long
    }
    
    func beerInDB() -> Bool{
        
        //makeBeerItem()
        
        let realm = try! Realm()
        let beers = Array(realm.objects(Beer.self))
        
        
        
        if(beers.contains(self.beer)){
            return true
        }else{
            
            return false
        }
    }

}
