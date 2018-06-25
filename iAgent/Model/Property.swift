//
//  Property.swift
//  iAgent
//
//  Created by Pavan Gopal on 6/24/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

class Property: Decodable {
    var facilities: [Facilty]
    var exclusions: [[Exclusion]]
    
    
}
