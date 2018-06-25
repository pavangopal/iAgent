//
//  CoreData+Helper.swift
//  iAgent
//
//  Created by Pavan Gopal on 6/25/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Helper{
    
    class func propertyItemForDictionary(dict: Any) -> PropertyCore? {
        
        let newObject = coreDataObjectForPredicate(entityName: "PropertyCore") as! PropertyCore
        
        newObject.propertyData = NSKeyedArchiver.archivedData(withRootObject: dict)
        newObject.date = Date()
        return newObject
        
    }
    
    class func coreDataObjectForPredicate(entityName: String) -> AnyObject {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: appDelegate.persistentContainer.viewContext)
        
    }
    
    class func dictionaryFromData(binaryData : Data?) -> Data {
        
        guard let unwrappedData = binaryData else{
            print("binaryData is NILL")
            return Data()
        }
        
        return NSKeyedUnarchiver.unarchiveObject(with: unwrappedData) as! Data
    }
    
    class func fetchAllpropertyItems() -> PropertyCore?{
        
        let fetchRequest = NSFetchRequest<PropertyCore>(entityName: "PropertyCore")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var result: [PropertyCore]?
        do {
            result = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        guard let unwrappedResult = result?.first else{
            print("unwrappedResult is empty")
            return nil
        }
        
        return unwrappedResult
    }
}
