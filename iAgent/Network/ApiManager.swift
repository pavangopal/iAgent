//
//  ApiManager.swift
//  iAgent
//
//  Created by Pavan Gopal on 6/24/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import RxSwift

class ApiManager {
    
    func getProperty(url:String,success:@escaping (Property) -> (),failure:@escaping (Error)->()){
        
        //MARK: Fetching Cached Data
        
        if let savedData = Helper.fetchAllpropertyItems() {
            if Calendar.current.compare(savedData.date!, to: Date(), toGranularity: .day) == ComparisonResult.orderedAscending {
                makeApiCall(url: url, success: { (property) in
                    success(property)
                }, failure: { (error) in
                    failure(error)
                })
            }else{
                let decoder = JSONDecoder()
                do{
                    let data = Helper.dictionaryFromData(binaryData: savedData.propertyData)
                    let property = try decoder.decode(Property.self, from: data)
                    DispatchQueue.main.async {
                        success(property)
                    }
                }catch let error{
                    failure(error)
                }
            }
           
        }else{
            makeApiCall(url: url, success: { (property) in
                success(property)
            }, failure: { (error) in
                failure(error)
            })
        }
    }
    
    func makeApiCall(url:String,success:@escaping (Property) -> (),failure:@escaping (Error)->()){
        guard let url = URL(string: url) else{
            failure(NetworkError.InvalidURL)
            return
        }
        
        let dataTask =  URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let dataObject = data else {
                failure(NetworkError.IncorrectDataReturned)
                return
            }
            
            DispatchQueue.main.async {
                
                let decoder = JSONDecoder()
                do{
                    let property = try decoder.decode(Property.self, from: dataObject)
                    success(property)
                    
                    //MARK: Persistance
                    _ = Helper.propertyItemForDictionary(dict: dataObject)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.saveContext()
                }catch let error{
                    failure(error)
                }
            }
        }
        
        dataTask.resume()
    }
}

