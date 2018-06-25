//
//  OptionCellModel.swift
//  iAgent
//
//  Created by Pavan Gopal on 6/24/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation


struct OptionCellModel{
    
    var optionName: String
    var icon:String
    var isDisabled:Bool = false
    var isSelected: Bool = false
}

struct FaciltyUserModel {

    var title:String
    
    var options:[OptionCellModel]
}
