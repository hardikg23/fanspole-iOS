//
//  User.swift
//  fanspole
//
//  Created by Hardik on 27/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import RealmSwift

class User: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var slug = ""
    dynamic var teamName = ""
    dynamic var image = ""
    dynamic var country = ""
    dynamic var level = 0
    dynamic var levelName = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
