//
//  EventCell.swift
//  fanspole
//
//  Created by Hardik on 20/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell{
    
    var classEvent: Event?
//    open var datasourceItem: Any?
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTeams: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventTeamOneImage: UIImageView!
    @IBOutlet weak var eventTeamTwoImage: UIImageView!
    
    @IBOutlet weak var leaderboardButton: UIButton!
    
    var datasourceItem: Any?{
        didSet{
            guard let event = datasourceItem as? Event else { return }
            classEvent = event
            
            eventTitle.text = "Match \(event.matchNo) (\(event.matchStage))"
            eventTeams.text = "\(event.teamOne.nameAttr) vs \(event.teamTwo.nameAttr)"
            eventTime.text = "\(event.getEventLockTimeAsString())"
            eventTeamOneImage.loadImageUsingCache(withUrl: event.teamOne.flagPhoto)
            eventTeamTwoImage.loadImageUsingCache(withUrl: event.teamTwo.flagPhoto)
        }
    }
}
