 //
//  CoreDataStack.swift
//  NoterCoreData-storyboard
//
//  Created by Rdm on 26/06/2020.
//  Copyright © 2020 Rdm. All rights reserved.
//

import Foundation
import CoreData

 
 class CoreDataStack {
    
    var container: NSPersistentContainer {
        
        let container = NSPersistentContainer(name: "NoteModel")
        container.loadPersistentStores { (success, error) in
            
            guard error == nil else {
                
                print("Error: \(error!)")
                return
            }
        }
        return container
    }
    
    var managedContext: NSManagedObjectContext {
        
        return container.viewContext
   
    }
 }
