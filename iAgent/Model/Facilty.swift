//
//  Facilty.swift
//  iAgent
//
//  Created by Pavan Gopal on 6/24/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

class Facilty: Decodable {
    
    let id:String
    let name:String
    var options:[Option]
    
    var isSelected:Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case id = "facility_id"
        case name
        case options
    }
    
}

class Option: Decodable {
    
    let id: String
    let name: String
    let icon: String
    
    var isDisabled:Bool? = false
    var isSelected:Bool? = false
    
}
