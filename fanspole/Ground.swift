//
//  Ground.swift
//  fanspole
//
//  Created by Hardik on 21/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import RealmSwift

class Ground: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var location = ""
    dynamic var country = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
