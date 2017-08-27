//
//  Event.swift
//  fanspole
//
//  Created by Hardik on 20/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//


import Foundation
//import SwiftyJSON
import RealmSwift

class Event: Object {
    dynamic var id = 0
    dynamic var eventTime = ""
    dynamic var eventLockTime = ""
    dynamic var matchType = ""
    dynamic var matchNo = 0
    dynamic var matchStage = ""
    dynamic var topicId = 0
    dynamic var seriesId = 0
    dynamic var groundId = 0
    dynamic var teamOneId = 0
    dynamic var teamTwoId = 0
    dynamic var eventType = ""
    dynamic var eventOrder = ""

    override static func primaryKey() -> String? {
        return "id"
    }

}
