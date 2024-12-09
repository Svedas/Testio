//
//  Server+CoreDataProperties.swift
//  
//
//  Created by Mantas Svedas on 05/12/2024.
//
//

import CoreData
import Foundation

extension Server {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Server> {
        return NSFetchRequest<Server>(entityName: "Server")
    }

    @NSManaged public var name: String?
    @NSManaged public var distance: Int64
}
