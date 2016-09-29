//
//  DetailTableViewController.swift
//  Aggregate
//
//  Created by Matt Long on 6/22/15.
//  Copyright © 2015 Matt Long. All rights reserved.
//

import UIKit
import CoreData

class DetailTableViewController: UITableViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var managedObjectContext:NSManagedObjectContext?
    
    var productLine:String? {
        didSet {
            self.title = productLine!
            self.products = Product.productsForProductLine(productLine: productLine!, managedObjectContext: self.managedObjectContext!)
        }
    }
    
    var products:[Product]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath as IndexPath)
        
        if let product = self.products?[indexPath.row] {
            cell.textLabel?.text = product.fullNameWithCounts
        }
        
        return cell
    }


}

