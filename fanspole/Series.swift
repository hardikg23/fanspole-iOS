//
//  Series.swift
//  fanspole
//
//  Created by Hardik on 21/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Series {
    let id: Int
    let name: String
    let indexValue: Int
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.indexValue = json["index_value"].intValue
    }
}

