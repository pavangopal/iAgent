//
//  Exclusion.swift
//  iAgent
//
//  Created by Pavan Gopal on 6/24/18.
//  Copyright © 2018 Pavan Gopal. All rights reserved.
//

import Foundation

class Exclusion: Decodable {
    
    let facilityId: String
    let optionId: String
    
    enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case optionId = "options_id"
    }
}
