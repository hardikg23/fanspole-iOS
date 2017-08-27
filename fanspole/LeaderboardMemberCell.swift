//
//  LeaderboardMemberCell.swift
//  fanspole
//
//  Created by Hardik on 27/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import UIKit

class LeaderboardMemberCell: UICollectionViewCell{
    
    @IBOutlet weak var memberRank: UILabel!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberTeamName: UILabel!
    @IBOutlet weak var memberLevel: UILabel!
    @IBOutlet weak var memberPoints: UILabel!
    
    var datasource: Any?{
        didSet{
            
            guard let member = datasource as? LeaderboardMember else { return }
            
            memberRank.text = "\(member.rank)"
            memberName.text = member.user?.name
            memberTeamName.text = member.user?.teamName
            if let level = member.user?.level, let levelName = member.user?.levelName {
                memberLevel.text = "Level \(level) - \(levelName)"
            }
            memberPoints.text = "\(member.totalScore)"
        }
    }
    
}
