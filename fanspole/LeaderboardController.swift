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
    var series: Series?
    var matchId: Int?
    var match: Event?
    var members: Results<LeaderboardMember>?
    var memberRanks: Results<UserRank>?
    lazy var realm = try! Realm()

    @IBOutlet weak var leaderboardCollectionView: UICollectionView!
    @IBOutlet weak var leaderboardRankTeamCollectionView: UICollectionView!
    
    @IBOutlet weak var noMemberLable: UILabel!
    
    
    let leaderboardMemberCellId = "leaderboardMemberCellId"
    let leaderboardRankTeamMemberCellId = "leaderboardRankTeamMemberCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.matchId != nil {
            if let match = self.realm.objects(Event.self).filter("id = \(self.matchId!) and eventType = 'Match'").first {
                self.match = match
                self.matchId = match.id
            }
        } else if self.seriesId != nil {
            if let series = self.realm.objects(Series.self).filter("id = \(self.seriesId!)").first {
                self.series = series
                self.seriesId = series.id
            }
        } else {
            if let series = self.realm.objects(Series.self).sorted(byKeyPath: "indexValue").first {
                self.series = series
                self.seriesId = series.id
            }
        }
        
        if self.seriesId != nil {
            ApiService.sharedInstance.fetchSeriesLeaderboard(seriesId: self.seriesId!) { () in
                self.members = self.realm.objects(LeaderboardMember.self).filter("eventType = 'Series' AND eventId = \(self.seriesId!)")
                self.memberRanks = self.realm.objects(UserRank.self).filter("eventType = 'Series' AND userId = 1 AND eventId = \(self.seriesId!)")
                self.leaderboardCollectionView.reloadData()
                self.leaderboardRankTeamCollectionView.reloadData()
                self.setBackgroundColor()
                
            }
        }
        
        if self.matchId != nil {
            ApiService.sharedInstance.fetchMatchLeaderboard(matchId: self.matchId!) { () in
                self.members = self.realm.objects(LeaderboardMember.self).filter("eventType = 'Match' AND eventId = \(self.matchId!)")
                self.memberRanks = self.realm.objects(UserRank.self).filter("eventType = 'Match' AND userId = 1 AND eventId = \(self.matchId!)")
                self.leaderboardCollectionView.reloadData()
                self.leaderboardRankTeamCollectionView.reloadData()
                self.setBackgroundColor()
            }

        }
        
        leaderboardCollectionView.dataSource = self
        leaderboardRankTeamCollectionView.dataSource = self
        leaderboardCollectionView.delegate = self
        leaderboardRankTeamCollectionView.delegate = self
        setUpNavigationBarAndTabBar()
    }
    
    private func setBackgroundColor() {
        if self.members?.count == 0{
            noMemberLable.isHidden = false
            leaderboardCollectionView.backgroundColor = UIColor.white
        } else {
            noMemberLable.isHidden = true
            leaderboardCollectionView.backgroundColor = UIColor.lightGray
        }
    }
    
    private func setUpNavigationBarAndTabBar() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Leaderboard"
        if self.matchId != nil, let matchNo = self.match?.matchNo {
            titleLabel.text = " Match \(matchNo) - Leaderboard"
        }
        if let seriesName = self.series?.name {
            titleLabel.text = "  \(seriesName) Leaderboard"
        }
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        let customTabBarItem:UITabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(named: "ic_format_list_numbered")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "ic_format_list_numbered"))
        self.tabBarItem = customTabBarItem
        self.tabBarController?.tabBar.tintColor = UIColor.white
    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.leaderboardCollectionView{
            if let membersCount = members?.count {
                return membersCount
            } else {
                return 0
            }
        } else {
            if let memberRanksCount = memberRanks?.count {
                return memberRanksCount
            } else {
                return 0
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.leaderboardCollectionView{

            let cell = leaderboardCollectionView.dequeueReusableCell(withReuseIdentifier: leaderboardMemberCellId, for: indexPath) as! LeaderboardMemberCell
            if indexPath.row < (members?.count)! {
                cell.datasource = members?[indexPath.row]
            }
            cell.backgroundColor = UIColor.white
            return cell
        } else {
            let cell = leaderboardRankTeamCollectionView.dequeueReusableCell(withReuseIdentifier: leaderboardRankTeamMemberCellId, for: indexPath) as! LeaderboardRankTeamMemberCell
            cell.backgroundColor = UIColor.red
            if indexPath.row < (memberRanks?.count)! {
                cell.datasource = memberRanks?[indexPath.row]
            }
            cell.backgroundColor = UIColor.appThemeColor2()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.leaderboardCollectionView{
            return CGSize(width: view.frame.width, height: 80)
        } else {
            return CGSize(width: view.frame.width, height: 80)
        }
        
    }


}

