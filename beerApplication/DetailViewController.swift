//
//  DetailViewController.swift
//  beerApplication
//
//  Created by Thomas Laisnez on 18/01/17.
//  Copyright © 2017 Thomas Laisnez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var beerDescription: UITextView!
    @IBOutlet weak var beerCategory: UILabel!
    @IBOutlet weak var beerAlcoholPercentage: UILabel!
    @IBOutlet weak var beerOrganic: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    var beerId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(beerId)
        getBeer()
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
                    
                    let url = URL(string: jsonBeer["data"]["labels"]["icon"].stringValue)
                    
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                        DispatchQueue.main.async {
                            self.beerImage.image = UIImage(data: data!)
                        }
                    }
                }
                
                let beerLocation = CLLocationCoordinate2D(latitude: jsonBeer["data"]["breweries"][0]["locations"][0]["latitude"].doubleValue, longitude: jsonBeer["data"]["breweries"][0]["locations"][0]["longitude"].doubleValue)
                self.map.region = MKCoordinateRegion(center: beerLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                let pin = MKPointAnnotation()
                pin.coordinate = beerLocation
                self.map.addAnnotation(pin)
                
                
            }
        }

    }

}
