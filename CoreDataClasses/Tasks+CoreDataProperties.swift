//
//  Tasks+CoreDataProperties.swift
//  ToDoListwithCoreData
//
//  Created by Рамил Гаджиев on 05.09.2021.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var createDate: Date?
    @NSManaged public var descriptions: String?
    @NSManaged public var name: String?
    @NSManaged public var taskList: String?
    @NSManaged public var relationship: TaskList?

}

extension Tasks : Identifiable {

}
