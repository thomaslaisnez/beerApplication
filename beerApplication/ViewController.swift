
import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class ViewController: UIViewController {
    
    var categoryArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancelToMainViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func openLink(sender: AnyObject) {
        //UIApplication.shared.openURL(URL(string: "http://www.brewerydb.com")!)        was deprecated in iOS 10
        UIApplication.shared.open(URL(string: "http://www.brewerydb.com")!, options: [:], completionHandler: nil)
    }
    
    func getCategories() {
        Alamofire.request("https://api.brewerydb.com/v2/categories?key=e1fd665a365668c993581f17cbd0358e&format=json").responseJSON {
            (response) -> Void in
            
            if let value = response.result.value {
                let jsonBeer = JSON(value)
                
                for i in 0...11 {
                    if(!jsonBeer["data"][i]["name"].stringValue.isEmpty){
                        self.categoryArray.append(jsonBeer["data"][i]["name"].stringValue)
                    }
                }
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "toSearch"){
            let destination = segue.destination as! SearchViewController
            destination.categories = categoryArray
        }
        
    }

}

