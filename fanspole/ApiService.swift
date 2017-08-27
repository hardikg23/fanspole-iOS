//
//  Service.swift
//  fanspole
//
//  Created by Hardik on 26/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class ApiService {

    static let sharedInstance = ApiService()
    lazy var realm = try! Realm()
    
    func fetchEvents(order_type: String, completion: @escaping () -> ()) {
        
        let apiURL = "\(Constants.ApiScheme)://\(Constants.ApiHost)"
        let parameters: Parameters = ["order_type": order_type]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.getAccessToken())",
            "X-Fanspole-Client": "\(Constants.ClientValue)"
        ]
        Alamofire.request("\(apiURL)\(Constants.ApiVersion)\(Methods.Events)", method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let eventsJsonArray = json["data"]["events"].array {
                    for eventJson in eventsJsonArray {
                        let event = Event()
                        event.id = eventJson["id"].intValue
                        event.matchType = eventJson["match_type"].stringValue
                        event.matchNo = eventJson["match_no"].intValue
                        event.matchStage = eventJson["match_stage"].stringValue
                        event.eventTime = eventJson["event_time"].stringValue
                        event.eventLockTime = eventJson["event_lock_time"].stringValue
                        event.topicId = eventJson["topic_id"].intValue
                        event.seriesId = eventJson["series"]["id"].intValue
                        event.groundId = eventJson["ground"]["id"].intValue
                        event.teamOneId = eventJson["team1"].intValue
                        event.teamTwoId = eventJson["team2"].intValue
                        event.eventType = eventJson["event_type"].stringValue
                        event.eventOrder = order_type
                        
                        let series = Series()
                        series.id = eventJson["series"]["id"].intValue
                        series.name = eventJson["series"]["name"].stringValue
                        series.indexValue = eventJson["series"]["index_value"].intValue
                        
                        let ground = Ground()
                        ground.id = eventJson["ground"]["id"].intValue
                        ground.name = eventJson["ground"]["name"].stringValue
                        ground.location = eventJson["ground"]["location"].stringValue
                        ground.country = eventJson["ground"]["country"].stringValue
                        
                        try! self.realm.write() {
                            self.realm.add(event, update: true)
                            self.realm.add(series, update: true)
                            self.realm.add(ground, update: true)
                            
                        }
                    }
                }
                if let teamsJsonArray = json["data"]["teams"].array {
                    for teamJson in teamsJsonArray {
                        let team = Team()
                        team.id = teamJson["id"].intValue
                        team.name = teamJson["name"].stringValue
                        team.nameAttr = teamJson["name_attr"].stringValue
                        team.flagPhoto = teamJson["flag_photo"]["url"].stringValue
                        try! self.realm.write() {
                            self.realm.add(team, update: true)
                        }
                    }
                }
                completion()
            case .failure(let error):
                print(error);
            }
        }
    }
    
    
    func fetchSeriesLeaderboard(seriesId: Int, completion: @escaping () -> ()) {
        let apiURL = "\(Constants.ApiScheme)://\(Constants.ApiHost)"
        
        var seriesLeaderBoardURL: String = Methods.SeriesLeaderBoard
        if let idRange = seriesLeaderBoardURL.range(of: "{id}") {
            seriesLeaderBoardURL.replaceSubrange(idRange, with: String(seriesId))
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.getAccessToken())",
            "X-Fanspole-Client": "\(Constants.ClientValue)"
        ]
        Alamofire.request("\(apiURL)\(Constants.ApiVersion)\(seriesLeaderBoardURL)", method: .get, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let membersJsonArray = json["data"]["members"].array {
                    for membersJson in membersJsonArray {
                    
                        let leaderboardMember = LeaderboardMember()
                        
                        let user = User()
                        user.id = membersJson["id"].intValue
                        user.name = membersJson["display_name"].stringValue
                        user.slug = membersJson["slug"].stringValue
                        user.teamName = membersJson["team_name"].stringValue
                        user.image = membersJson["image"].stringValue
                        user.country = membersJson["country"].stringValue
                        user.level = membersJson["cricket_level"]["level"].intValue
                        user.levelName = membersJson["cricket_level"]["level_name"].stringValue
                        
                        leaderboardMember.userId = membersJson["id"].intValue
                        leaderboardMember.user = user
                        leaderboardMember.rank = membersJson["rank"].intValue
                        leaderboardMember.totalScore = membersJson["total_score"].intValue
                        leaderboardMember.eventType = "Series"
                        leaderboardMember.eventId = seriesId
                    
                        try! self.realm.write() {
                            self.realm.add(leaderboardMember, update: true)
                        }
                    }
                }
                completion()
            case .failure(let error):
                print(error);
            }
        }
        
        
        
    }

    
    
}
