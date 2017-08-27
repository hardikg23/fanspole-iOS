//
//  LeaderboardMember.swift
//  fanspole
//
//  Created by Hardik on 27/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import RealmSwift

class LeaderboardMember: Object {
    dynamic var userId = 0 {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    dynamic var user: User?
    dynamic var rank = 0
    dynamic var totalScore = 0
    dynamic var eventType = "" {
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    dynamic var eventId = 0{
        didSet {
            compoundKey = compoundKeyValue()
        }
    }
    
    public dynamic var compoundKey: String = ""
    public override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    private func compoundKeyValue() -> String {
        return "\(userId)-\(eventType)-\(eventId)"
    }
}

