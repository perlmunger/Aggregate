//
//  Product.swift
//  Aggregate
//
//  Created by Matt Long on 6/22/15.
//  Copyright © 2015 Matt Long. All rights reserved.
//

import Foundation
import CoreData

@objc
class Product: NSManagedObject {

    class var entityName : String {
        get {
            return "Product"
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = Product.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedObjectContext);
    }

    class func aggregateProductsInContext(context:NSManagedObjectContext) -> [[String:AnyObject]]? {

        // Create an array of AnyObject since it needs to contain multiple types--strings and
        // NSExpressionDescriptions
        var expressionDescriptions = [AnyObject]()
        
        // We want productLine to be one of the columns returned, so just add it as a string
        expressionDescriptions.append("productLine")
        
        // Create an expression description for our SoldCount column
        var expressionDescription = NSExpressionDescription()
        // Name the column
        expressionDescription.name = "SoldCount"
        // Use an expression to specify what aggregate action we want to take and
        // on which column. In this case sum on the sold column
        expressionDescription.expression = NSExpression(format: "@sum.sold")
        // Specify the return type we expect
        expressionDescription.expressionResultType = .Integer32AttributeType
        // Append the description to our array
        expressionDescriptions.append(expressionDescription)
        
        // Create an expression description for our ReturnedCount column
        expressionDescription = NSExpressionDescription()
        // Name the column
        expressionDescription.name = "ReturnedCount"
        // Use an expression to specify what aggregate action we want to take and
        // on which column. In this case sum on the returned column
        expressionDescription.expression = NSExpression(format: "@sum.returned")
        // Specify the return type we expect
        expressionDescription.expressionResultType = .Integer32AttributeType
        // Append the description to our array
        expressionDescriptions.append(expressionDescription)
        
        // Build out our fetch request the usual way
        let request = NSFetchRequest(entityName: self.entityName)
        // This is the column we are grouping by. Notice this is the only non aggregate column.
        request.propertiesToGroupBy = ["productLine"]
        // Specify we want dictionaries to be returned
        request.resultType = .DictionaryResultType
        // Go ahead and specify a sorter
        request.sortDescriptors = [NSSortDescriptor(key: "productLine", ascending: true)]
        // Hand off our expression descriptions to the propertiesToFetch field. Expressed as strings
        // these are ["productLine", "SoldCount", "ReturnedCount"] where productLine is the value
        // we are grouping by.
        request.propertiesToFetch = expressionDescriptions
        
        // Our result is going to be an array of dictionaries.
        var results:[[String:AnyObject]]?
        
        // Perform the fetch. This is using Swfit 2, so we need a do/try/catch
        do {
            results = try context.executeFetchRequest(request) as? [[String:AnyObject]]
        } catch _ {
            // If it fails, ensure the array is nil
            results = nil
        }
        
        return results
    }
    
    class func productsForProductLine(productLine:String, managedObjectContext:NSManagedObjectContext) -> [Product]? {
        let request = NSFetchRequest(entityName: self.entityName)
        request.predicate = NSPredicate(format: "productLine = %@", productLine)
        request.sortDescriptors = [NSSortDescriptor(key: "productName", ascending: true)]
        
        var results:[Product]?
        
        do {
            results = try managedObjectContext.executeFetchRequest(request) as? [Product]
        } catch {
            results = nil
        }
        
        return results
    }
    
    var fullName : String {
        return String(format: "%@: %@", self.productLine ?? "", self.productName ?? "")
    }
    
    var fullNameWithCounts : String {
        return String(format: "%@ Sold: %d, Returned: %d", self.fullName, self.sold ?? 0, self.returned ?? 0)
    }
}
