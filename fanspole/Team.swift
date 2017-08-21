//
//  Team.swift
//  fanspole
//
//  Created by Hardik on 21/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//


import Foundation
import SwiftyJSON

struct Team {
    let id: Int
    let name: String
    let nameAttr: String
    let slug: String
    let teamColor: String
    let captainId: Int
    let topicId: Int
    let flagPhoto: String
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.nameAttr = json["name_attr"].stringValue
        self.slug = json["slug"].stringValue
        self.teamColor = json["team_color"].stringValue
        self.captainId = json["captain_id"].intValue
        self.topicId = json["topic_id"].intValue
        self.flagPhoto = json["flag_photo"]["url"].stringValue
    }
}

