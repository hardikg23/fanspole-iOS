//
//  ApiServiceConstants.swift
//  fanspole
//
//  Created by Hardik on 26/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

extension ApiService {
    
    struct Constants {
        
        // MARK: API Key
        static let ClientKey = "X-Fanspole-Client"
        static let ClientValue = "254b4f821a12144966c43444039dca21b97dde0be39b1fc1d2f573228dea6bbb"
        
        // MARK: URLs
        static let ApiScheme = "http"
        static let ApiHost = "localhost:3000/api"
        static let ApiVersion = "/v2"
    }
    
    struct Methods {
        
        // MARK: Account
        static let Events = "/events"
        static let UserCards = "/users/cards"
        static let MatchLeaderBoard = "/matches/{id}/leaderboard"
        static let ViewTeam = "/users/{user_id}/match/{match_id}/team"
    }
    
    
}

