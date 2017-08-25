//
//  EventCell.swift
//  fanspole
//
//  Created by Hardik on 20/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import UIKit
import RealmSwift

class EventCell: UICollectionViewCell{
    
    let realm = try! Realm()
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTeams: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventTeamOneImage: UIImageView!
    @IBOutlet weak var eventTeamTwoImage: UIImageView!
    
    @IBOutlet weak var leaderboardButton: UIButton!
    
    var datasourceEvent: Any?{
        didSet{
            guard let event = datasourceEvent as? Event else { return }
    
            let teamOne = realm.objects(Team.self).filter("id = \(event.teamOneId)").first
            let teamTwo = realm.objects(Team.self).filter("id = \(event.teamTwoId)").first
            
            eventTitle.text = "Match \(event.matchNo) (\(event.matchStage))"
            eventTeams.text = "\(String(describing: teamOne!.nameAttr)) vs \(teamTwo!.nameAttr)"
            let std = StringToDate()
            let date = std.getDateFromString(dateString: event.eventLockTime)
            eventTime.text = "\(std.formatStringToDate(date: date))"
            eventTeamOneImage.loadImageUsingCache(withUrl: (teamOne?.flagPhoto)!)
            eventTeamTwoImage.loadImageUsingCache(withUrl: (teamTwo?.flagPhoto)!)
        }
    }
}
