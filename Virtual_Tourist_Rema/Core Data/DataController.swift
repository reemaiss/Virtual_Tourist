//
//  DataController.swift
//  Virtual_Tourist_Rema
//
//  Created by Rema alsuwailm on 26/05/1442 AH.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer : NSPersistentContainer
    let backgroundContext: NSManagedObjectContext!
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(name:String) {
        persistentContainer = NSPersistentContainer(name: name)
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func configureNewContext(){
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func autoSaveContext(interval: TimeInterval = 30){
        
    }
    
    func load(completion: (() -> Void)? = nil ){
        persistentContainer.loadPersistentStores { ( sort, error ) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveContext()
            self.configureNewContext()
            completion?()
        }
    }
    
}
