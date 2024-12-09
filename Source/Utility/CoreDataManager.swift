//
//  CoreDataManager.swift
//  Trends
//
//  Created by Mantas Svedas on 2020-09-07.
//  Copyright © 2020 Mantas Svedas. All rights reserved.
//

import CoreData
import Foundation

final class CoreDataManager {
    private enum Constant {
        fileprivate static let managedObjectModelName = "TestioModel"
        
        fileprivate static let persistentContainerName = "PersistentContainer"
        fileprivate static let persistentContainerMockName = "PersistentContainerMock"
    }
    
    // MARK: - Properties
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
        
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let bundle = Bundle(for: Self.self)
        guard
            let modelPath = bundle.url(
                forResource: Constant.managedObjectModelName,
                withExtension: "momd"
            )?.absoluteURL,
            let managedObjectModel = NSManagedObjectModel.init(contentsOf: modelPath)
        else {
            fatalError("Couldn't create managed object model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: Constant.persistentContainerName,
            managedObjectModel: managedObjectModel
        )
        
        container.persistentStoreDescriptions.forEach { storeDescription in
            storeDescription.shouldMigrateStoreAutomatically = true
            storeDescription.shouldInferMappingModelAutomatically = true
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Couldn't create an in-memory coordinator. \(error)")
            }
        }
        
        return container
    }()
    
    // MARK: - Public functionality
    
    func saveMainContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAllEntities(with fetchRequest: NSFetchRequest<NSFetchRequestResult>, from context: NSManagedObjectContext) {
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                if let objectData = object as? NSManagedObject {
                    context.delete(objectData)
                }
            }
            saveContext(context)
        } catch let error {
            debugPrint("Detele all \(fetchRequest.entity ?? NSEntityDescription()) failed with error: \(error)!")
        }
    }
    
    // MARK: - Testing functionality
    
    var testManagedObjectContext: NSManagedObjectContext {
        testPersistentContainer.viewContext
    }
    
    private var testPersistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(
            name: Constant.persistentContainerMockName,
            managedObjectModel: managedObjectModel
        )
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            precondition( description.type == NSInMemoryStoreType )
                                        
            if let error = error {
                fatalError("Couldn't create an in-memory coordinator. \(error)")
            }
        }
        
        return container
    }
}
