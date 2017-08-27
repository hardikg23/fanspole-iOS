//
//  Team.swift
//  fanspole
//
//  Created by Hardik on 21/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import RealmSwift

class Team: Object{
    dynamic var id = 0
    dynamic var name = ""
    dynamic var nameAttr = ""
    dynamic var slug = ""
    dynamic var teamColor = ""
    dynamic var captainId = 0
    dynamic var topicId = 0
    dynamic var flagPhoto = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
