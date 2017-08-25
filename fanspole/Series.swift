//
//  Series.swift
//  fanspole
//
//  Created by Hardik on 21/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import Foundation
//import SwiftyJSON
import RealmSwift

class Series: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var indexValue = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

//struct Series {
//    let id: Int
//    let name: String
//    let indexValue: Int
//    
//    init(json: JSON) {
//        self.id = json["id"].intValue
//        self.name = json["name"].stringValue
//        self.indexValue = json["index_value"].intValue
//    }
//}
//
