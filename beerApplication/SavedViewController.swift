
import UIKit
import RealmSwift

class SavedViewController: UITableViewController {
    
    @IBOutlet var myBeersTableView: UITableView!
    
    var beers: [Beer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBeersFromDB()
    }
    
    @IBAction func unwindToSavedBeers(segue: UIStoryboardSegue) {}          //word gebruikt om terug naar lijstscherm te gaan - maar die knop is vervangen door toevoegen en verwijderen van bieren uit je bierlijst - bij verwijderen van bier ga je wel terug naar de opgeslagen bierlijst
    
    func getBeersFromDB() {
        let realm = try! Realm()                            //Realm documentation
        self.beers = Array(realm.objects(Beer.self))
  
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
        
        cell.cellLabel.text = beers[indexPath.item].name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DetailViewController
        let index = myBeersTableView.indexPathsForSelectedRows!.first!.row
        destination.beer = beers[index]
    }
    
    override func viewWillAppear(_ animated: Bool) {            //zorgen dat alle bieren altijd in de lijst weergeven worden na update
        getBeersFromDB()
        self.myBeersTableView.reloadData()
    }

}
