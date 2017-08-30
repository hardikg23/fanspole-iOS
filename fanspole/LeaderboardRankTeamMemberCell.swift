//
//  LeaderboardRankTeamMemberCell.swift
//  fanspole
//
//  Created by Hardik on 30/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import UIKit

class LeaderboardRankTeamMemberCell: UICollectionViewCell{

    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var teamStackView: UIStackView!
    
    var datasource: Any?{
        didSet{

            guard let userRank = datasource as? UserRank else { return }
            
            if userRank.eventType == "Series" {
                teamStackView.isHidden = true
            } else {
                teamLabel.text = "\(userRank.teamNo)"
            }
            rankLabel.text = "\(userRank.rank)"
            scoreLabel.text = "\(userRank.score)"
            membersLabel.text = "\(userRank.members)"
        }
    }
}

