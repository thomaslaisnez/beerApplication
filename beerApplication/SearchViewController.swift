
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
        
        beers.removeAll()
        ids.removeAll()
        text.text = ""
        
        category.dataSource = self
        category.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))         // Source: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift       - dismiss keyboard when you tap somewhere else
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissKeyboard() {                //also used for dismissing the keyboard
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "textSearch"){
            let destination = segue.destination as! SearchResultViewController
            destination.searchQuery = text.text
        }
        if(segue.identifier == "categorySearch"){
            let destination = segue.destination as! SearchResultViewController
            destination.searchQuery = selectedCategory
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
    
    @IBAction func primaryActionTriggered(_ sender: Any) {
        dismissKeyboard()
    }

}
