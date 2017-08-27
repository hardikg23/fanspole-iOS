//
//  SecondViewController.swift
//  fanspole
//
//  Created by Hardik on 20/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import UIKit
import RealmSwift

class LeaderboardController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var seriesId: Int?
    var matchId: Int?

    @IBOutlet weak var leaderboardCollectionView: UICollectionView!
    @IBOutlet weak var memberInfoView: UIView!
    
    let leaderboardMemberCellId = "leaderboardMemberCellId"
    
    var members: Results<LeaderboardMember>?
    lazy var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiService.sharedInstance.fetchSeriesLeaderboard(seriesId: 42) { () in
//            self.events = self.realm.objects(Event.self).filter("eventOrder = '\(order_type)' AND eventType = 'Match'")
            self.members = self.realm.objects(LeaderboardMember.self).filter("eventType = 'Series' AND eventId = 42")
            self.leaderboardCollectionView.reloadData()
        }
        
        leaderboardCollectionView.dataSource = self
        leaderboardCollectionView.delegate = self
        leaderboardCollectionView.backgroundColor = UIColor.lightGray
        memberInfoView.backgroundColor = UIColor.appThemeColor2()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let membersCount = members?.count {
            return membersCount
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = leaderboardCollectionView.dequeueReusableCell(withReuseIdentifier: leaderboardMemberCellId, for: indexPath) as! LeaderboardMemberCell
        if indexPath.row < (members?.count)! {
            cell.datasource = members?[indexPath.row]
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }


}

