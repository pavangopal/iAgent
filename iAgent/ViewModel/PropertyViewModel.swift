//
//  PropertyViewModel.swift
//  iAgent
//
//  Created by Pavan Gopal on 6/24/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation
import RxSwift
import CoreData

protocol PropertyViewModeling {
    // MARK: - Input
    var cellDidSelect: PublishSubject<IndexPath> { get }
    var facilityArray: [NSManagedObject]{get}

    //     MARK: - Output
    
    var faciltyUserModelObserver:Variable<[FaciltyUserModel]>{get}
    func getProperty()
}

class PropertyViewModel:PropertyViewModeling{
    
    // MARK: - Input
    var apiManager: ApiManager
    let cellDidSelect: PublishSubject<IndexPath> = PublishSubject<IndexPath>()
    var facilityArray: [NSManagedObject] = []
    
    // MARK: - Output
    var faciltyUserModel:[FaciltyUserModel] = []{
        didSet{
            faciltyUserModelObserver.value = faciltyUserModel
        }
    }
    
    var faciltyUserModelObserver:Variable<[FaciltyUserModel]> = Variable<[FaciltyUserModel]>([])
    
    var optionsSelected:Observable<Option>!
    
    var property:Property?{
        didSet{
            //is safe to force unwrap because property will already be set in `didSet`
            self.generateFacilityUserModel(property:property!)
        }
    }
    
    init(apiManager:ApiManager){
        
        self.apiManager = apiManager
        
       _ = cellDidSelect.subscribe { (indexOption) in
        //Reset the selection
            _ = self.property?.facilities.flatMap({$0}).flatMap({$0}).map({$0.options.map({$0.isDisabled = false})})
        
            if let indexPath = indexOption.element{
                
                let selectedfacility = self.property?.facilities[indexPath.section]
                let selectedOption = self.property?.facilities[indexPath.section].options[indexPath.row]
                
                selectedfacility?.isSelected = true
                _ = selectedfacility?.options.map({$0.isSelected = false})
                selectedOption?.isSelected = true
                
             let flatOptionArray = self.property?.facilities.map({$0.options}).flatMap({$0})
                let flatFacilityArray = self.property?.facilities.filter({$0.isSelected == true})
                
                if let totalSelectedOptionsArray = flatOptionArray?.filter({$0.isSelected == true}), let totalSelectedFacilityArray = flatFacilityArray{
                    
                    for facility in totalSelectedFacilityArray{
                        for option in totalSelectedOptionsArray{
                            
                            if let selectedExclusion = self.property?.exclusions.map({$0.index(where: {$0.facilityId == facility.id && $0.optionId == option.id})}),let index = selectedExclusion.index(where: {$0 != nil}){

                                let exclusionPair = self.property?.exclusions[index]
                                if let index = exclusionPair?.index(where: {$0.optionId == option.id}){
                                    let toBeExcludedIndex = (index == 0) ? 1 : 0
                                    let toBeExcluded = exclusionPair?[toBeExcludedIndex]
                                    
                                    let excludedFacilityIndex = self.property?.facilities.index(where: {$0.id == toBeExcluded?.facilityId})
                                    let excludedFacility = self.property?.facilities[excludedFacilityIndex!]
                                    
                                    let optionRemove = excludedFacility?.options.first(where: {$0.id == toBeExcluded?.optionId})
                                    optionRemove?.isDisabled = true
                                    optionRemove?.isSelected = false
                                    self.property?.facilities[excludedFacilityIndex!] = excludedFacility!
                                }
                                
                            }
                        }
                    }
                    
                    self.generateFacilityUserModel(property: self.property!)
                }
            }
        }
    }
    
    func getProperty(){
        apiManager.getProperty(url: URLConstant.propertyUrl, success: { (response) in
            self.property = response
        }) { (error) in
            print(error)
        }
    }
    
    func generateFacilityUserModel(property:Property){
        var faciltyUserModel = [FaciltyUserModel]()
        
        
        for facility in property.facilities {
            
            var optionCellModelArray = [OptionCellModel]()
            for option in facility.options{
                optionCellModelArray.append(OptionCellModel(optionName: option.name, icon: option.icon,isDisabled:option.isDisabled ?? false, isSelected: option.isSelected ?? false))
            }
            
            faciltyUserModel.append(FaciltyUserModel(title: facility.name, options: optionCellModelArray))
        }
        
        self.faciltyUserModel = faciltyUserModel
    }
    
}
