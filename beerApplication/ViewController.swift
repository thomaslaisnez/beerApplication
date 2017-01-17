//
//  ViewController.swift
//  beerApplication
//
//  Created by Thomas Laisnez on 12/01/17.
//  Copyright © 2017 Thomas Laisnez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelToMainViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func openLink(sender: AnyObject) {
        //UIApplication.shared.openURL(URL(string: "http://www.brewerydb.com")!)    was deprecated in iOS 10
        UIApplication.shared.open(URL(string: "http://www.brewerydb.com")!, options: [:], completionHandler: nil)
    }

}

