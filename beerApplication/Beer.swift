
import UIKit
import RealmSwift

class Beer: Object{
    
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var desc: String = ""
    dynamic var category: String = ""
    dynamic var alcoholPercentage: String = ""
    dynamic var organic: String = ""
    dynamic var imageURL: String = ""
    dynamic var breweryLongitude: Double = 0.0
    dynamic var breweryLatitude: Double = 0.0
    
}
