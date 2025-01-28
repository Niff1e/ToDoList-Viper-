//
//  TaskCoreDataEntity+CoreDataProperties.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 24.01.25.
//
//

import Foundation
import CoreData


extension TaskCoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCoreDataEntity> {
        return NSFetchRequest<TaskCoreDataEntity>(entityName: "TaskCoreDataEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var descriptions: String?

}

extension TaskCoreDataEntity : Identifiable {

}
