//
//  DataStoreManager.swift
//  ToDoListwithCoreData
//
//  Created by Рамил Гаджиев on 04.09.2021.
//

import Foundation
import UIKit
import CoreData


class DataStore{
    static var shared = DataStore()
    
    private init() {}
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func saveTaskList(name: String) -> TaskList {
        let taskList = TaskList(context: context)
        taskList.name = name
        do {
            try context.save()
        } catch let error as NSError {
            print (error.localizedDescription)
        }
        return taskList
    }
    
    
    
    func saveTask(taskList: TaskList, name: String, description: String) -> Tasks {
        let task = Tasks(context: context)
        task.name = name
        task.descriptions = description
        task.taskList = taskList.name
        task.completed = false
        taskList.addToRelationship(task)
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return task
    }
    
    
    
    func fetchTaskList () -> [TaskList] {
        var taskLists = [TaskList]()
        let request:NSFetchRequest<TaskList> = TaskList.fetchRequest()
        
        do {
            taskLists = try context.fetch(request)
        } catch let error as NSError {
            print (error.localizedDescription)
        }
        return taskLists
    }
    
    
    
    func fetchTask (taskList: TaskList, completed: Bool?) -> [Tasks] {
        
        var tasks = [Tasks]()
        NSCondition
        let request: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        let taskListName = taskList.name!
        if completed == nil {
            request.predicate = NSPredicate(format: "taskList == %@", taskListName)
        } else {
            request.predicate = NSPredicate(format: "taskList == %@ AND completed == %d", taskListName, completed!)
        }
        do {
        
            tasks = try context.fetch(request)
            
        } catch let error as NSError {
            print (error.localizedDescription)
        }
        if !tasks.isEmpty {
            return tasks
        } else {
            return [Tasks]()
        }
    }

    
    
    func fetchAndChangeTask (task: Tasks, completed: Bool) {
        task.completed = completed
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    func deleteTaskList(taskList:TaskList) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskList")
        request.predicate = NSPredicate(format: "name = %@", taskList.name!)
        do {
           let taskLists = try context.fetch(request) as! [TaskList]
            for taskList in taskLists {
            context.delete(taskList)
            }
            try context.save()
        } catch let error as NSError {
            print (error.localizedDescription)
        }
    }
    
    
    func deleteTask (taskList:TaskList, task: Tasks) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        request.predicate = NSPredicate(format: "taskList = %@ AND name = %@", taskList.name!, task.name!)
        do {
           let tasks = try context.fetch(request) as! [Tasks]
            for task in tasks {
            context.delete(task)
            }
            try context.save()
        } catch let error as NSError {
            print (error.localizedDescription)
        }
    }
    
    
    
    func deleteAllTaskLists () {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error as NSError {
            print (error.localizedDescription)
        }
    }
}
