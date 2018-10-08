//
//  CoreDataConnection.swift
//  MachineCypher
//
//  Created by Sonal Verma on 2018-08-03.
//  Copyright © 2018 Sonal Verma. All rights reserved.
//

import UIKit
import CoreData

class CoreDataConnection: NSObject {
    static let sharedInstance = CoreDataConnection()
    
    static let kItem = "Agent"
    static let kFilename = "MachineCypher"
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: CoreDataConnection.kFilename)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Adding More Helpers
    
    func createManagedObject( entityName: String )->NSManagedObject {
        
        let managedContext =
            CoreDataConnection.sharedInstance.persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: entityName,
                                       in: managedContext)!
        
        let item = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        return item
        
    }
    
    
    func saveDatabase(completion:(_ result: Bool ) -> Void) {
        
        let managedContext =
            CoreDataConnection.sharedInstance.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            
            completion(true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
        
    }
    
    func deleteManagedObject( managedObject: NSManagedObject, completion:(_ result: Bool ) -> Void) {
        
        let managedContext =
            CoreDataConnection.sharedInstance.persistentContainer.viewContext
        
        managedContext.delete(managedObject)
        
        do {
            try managedContext.save()
            
            completion(true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
        
    }
    
    func deleteDataCoreData(){
        let managedContext = CoreDataConnection.sharedInstance.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Agent")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            let result = try managedContext.execute(request)
            print(result)
        } catch {
            print ("There was an error")
        }
    }
    
    
//    func fetch(entity: String) -> [NSManagedObject]? {
//        let managedContext =
//            CoreDataConnection.sharedInstance.persistentContainer.viewContext
//        var request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        var error: NSError?
//        if let entities = managedContext.executeFetchRequest(request, error: &error) as? [NSManagedObject] {
//            if entities.count > 0 {
//                return entities
//            }
//        }
//        return nil
//    }

    

}
