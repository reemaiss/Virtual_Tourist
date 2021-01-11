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
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
//    func autoSaveContext(interval: TimeInterval = 30){
//        guard interval > 0 else {
//            print("cant")
//            return
//        }
//
//        if viewContext.hasChanges {
//            try? viewContext.save()
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + interval ){
//            self.autoSaveContext(interval: interval)
//        }
//    }
    
    func load(completion: (() -> Void)? = nil ){
        persistentContainer.loadPersistentStores { ( sort, error ) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureNewContext()
            completion?()
        }
    }
    
}


extension DataController {
    func autoSaveViewContext(interval:TimeInterval = 30) {
        print("autosaving")
        
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
