//
//  TaskList+CoreDataProperties.swift
//  ToDoListwithCoreData
//
//  Created by Рамил Гаджиев on 05.09.2021.
//
//

import Foundation
import CoreData


extension TaskList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskList> {
        return NSFetchRequest<TaskList>(entityName: "TaskList")
    }

    @NSManaged public var name: String?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension TaskList {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Tasks)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Tasks)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}

extension TaskList : Identifiable {

}
