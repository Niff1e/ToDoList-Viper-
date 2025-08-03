//
//  TaskCoreDataEntity+CoreDataProperties.swift
//  ToDoList(Viper)
//
//  Created by Pavel Maal on 28.07.25.
//
//

import Foundation
import CoreData


extension TaskCoreDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCoreDataEntity> {
        return NSFetchRequest<TaskCoreDataEntity>(entityName: "TaskCoreDataEntity")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var date: Date?
    @NSManaged public var descriptions: String?
    @NSManaged public var name: String?
    @NSManaged public var id: Int64

}

extension TaskCoreDataEntity : Identifiable {

}
