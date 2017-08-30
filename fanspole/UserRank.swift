//
//  UserRank.swift
//  fanspole
//
//  Created by Hardik on 30/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import RealmSwift

class UserRank: Object {
    dynamic var userId = 0 {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    dynamic var teamNo = 1 {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    dynamic var eventId = 0{
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    dynamic var eventType = "" {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    dynamic var rank = 0
    dynamic var score = 0
    dynamic var members = 0
    dynamic var teamText = ""
    
    public dynamic var compoundKey: String = ""
    public override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    private func compoundKeyValue() -> String {
        return "\(userId)-\(teamNo)-\(eventType)-\(eventId)"
    }
}


