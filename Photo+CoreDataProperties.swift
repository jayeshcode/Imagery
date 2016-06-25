//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by Anton Moiseev on 2016-06-22.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var image: NSData?

}
