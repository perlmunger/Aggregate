//
//  Product+CoreDataProperties.swift
//  Aggregate
//
//  Created by Matt Long on 6/22/15.
//  Copyright © 2015 Matt Long. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Product {

    @NSManaged var timeStamp: NSDate?
    @NSManaged var productLine: String?
    @NSManaged var productName: String?
    @NSManaged var sold: NSNumber?
    @NSManaged var returned: NSNumber?

}
