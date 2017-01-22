
import UIKit
import Alamofire
import SwiftyJSON

class SearchResultViewController: UITableViewController {
    
    @IBOutlet var searchResultsTableView: UITableView!
    
    var searchQuery : String?
    var beers: [String] = []
    var ids: [String] = []

    override func viewDidLoad() {
        print(searchQuery!)
        getResultFromQuery(queryString: searchQuery!)
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
                        self.ids.append(jsonBeer["data"][i]["id"].stringValue)
                        self.beers.append(jsonBeer["data"][i]["name"].stringValue)
                        print(self.beers)
                    }
                }
                
            }
            self.searchResultsTableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        let index = searchResultsTableView.indexPathsForSelectedRows!.first!.row
        destination.beerId = ids[index]
    }

    
}
