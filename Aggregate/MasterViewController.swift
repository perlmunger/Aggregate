//
//  MasterViewController.swift
//  Aggregate
//
//  Created by Matt Long on 6/22/15.
//  Copyright © 2015 Matt Long. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailTableViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil

    var productsAggregate:[[String:AnyObject]]?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailTableViewController
        }
        
        self.productsAggregate = Product.aggregateProductsInContext(context: self.managedObjectContext!)
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let product = self.productsAggregate?[indexPath.row] {
                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailTableViewController
                    controller.managedObjectContext = self.managedObjectContext
                    controller.productLine = product["productLine"] as? String
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    
                }
            }
        }
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productsAggregate?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)

        if let aggregate = self.productsAggregate?[indexPath.row] {
            if let productLine = aggregate["productLine"] as? String,
                let soldCount = aggregate["SoldCount"] as? Int,
                let returnedCount = aggregate["ReturnedCount"] as? Int {
                    cell.textLabel?.text = productLine
                    let labelText = String(format: "Sold: %d, Returned: %d", soldCount, returnedCount)
                    cell.detailTextLabel?.text = labelText
            }
        }
        
        return cell
    }
}

