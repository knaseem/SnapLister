//
//  Picture+CoreDataProperties.swift
//  SnapLister
//
//  Created by Khalid Naseem on 21/07/2016.
//  Copyright © 2016 Khalid Naseem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Picture {

    @NSManaged var image: NSData?
    @NSManaged var title: String?
    @NSManaged var location: String?

}
