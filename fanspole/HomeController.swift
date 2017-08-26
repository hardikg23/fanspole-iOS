//
//  FirstViewController.swift
//  fanspole
//
//  Created by Hardik on 20/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift


class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var homeMenuCollectionView: UICollectionView!
    
    let cellId = "eventCellId"
    let homeMenuCellId = "homeMenuCellId"
    var events: Results<Event>?
    let menuItem = ["Live", "Upcoming", "Results"]
    lazy var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        print("Realm Path \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleSignOut))
        
        homeMenuCollectionView.backgroundColor = UIColor(red: 31/255, green: 51/255, blue: 71/255, alpha: 1)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(UserDefaults.standard.getAccessToken())",
            "X-Fanspole-Client": "254b4f821a12144966c43444039dca21b97dde0be39b1fc1d2f573228dea6bbb"
        ]
        Alamofire.request("http://localhost:3000/api/v2/events",method: .get, headers: headers).validate().responseJSON { response in
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
                    self.events = self.realm.objects(Event.self)
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
                self.eventCollectionView.reloadData()
            case .failure(let error):
                print(error);
            }
        }
        self.eventCollectionView.delegate = self
        self.eventCollectionView.dataSource = self
        self.homeMenuCollectionView.delegate = self
        self.homeMenuCollectionView.dataSource = self
        
        setupHorizontalBar()
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        homeMenuCollectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        homeMenuCollectionView.addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: homeMenuCollectionView.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.topAnchor.constraint(equalTo: homeMenuCollectionView.topAnchor, constant: 46).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: homeMenuCollectionView.widthAnchor, multiplier: 1/3).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.homeMenuCollectionView {
            print(indexPath.item)
            let x = CGFloat(indexPath.item) * view.frame.width / 3
            horizontalBarLeftAnchorConstraint?.constant = x
            UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            self.homeMenuCollectionView.layoutIfNeeded()
            }, completion: nil)
        }
//                print(indexPath.item)
        //        let x = CGFloat(indexPath.item) * frame.width / 4
        //        horizontalBarLeftAnchorConstraint?.constant = x
        //
        //        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
        //            self.layoutIfNeeded()
        //            }, completion: nil)
        
//        homeController?.scrollToMenuIndex(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.eventCollectionView {
            if let eventsCount = events?.count {
                return eventsCount
            } else {
                return 0
            }
        } else {
            return 3
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.eventCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCell
            cell.datasourceEvent = events?[indexPath.row]
    //        cell.datasourceEvent = events[indexPath.row]
    //        To send match ID directly in tag
    //        cell.leaderboardButton.tag = events[indexPath.row].id
    //        to send index of event object
            cell.leaderboardButton.tag = indexPath.row
            cell.backgroundColor = UIColor(red: 31/255, green: 51/255, blue: 71/255, alpha: 1)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeMenuCellId, for: indexPath) as! HomeMenuCell
            cell.homeMenuCellLabel.text = menuItem[indexPath.row]
            cell.homeMenuCellLabel.textColor = UIColor.lightGray
            cell.backgroundColor = UIColor(red: 31/255, green: 51/255, blue: 71/255, alpha: 1)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.eventCollectionView {
            return CGSize(width: view.frame.width - 20, height: 190)
        }
        else {
            return CGSize(width: view.frame.width / 3, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "leaderboardSegue" {
            let leaderboardVC = segue.destination as! LeaderboardController
//        To send match ID directly in tag
//            if let matchId = (sender as AnyObject).tag {
//                leaderboardVC.matchId = matchId
//            }
//        To send index of event object
            if let index = (sender as AnyObject).tag {
                leaderboardVC.matchId = events?[index].id
            }

        }
    }
    
    override func viewDidLayoutSubviews() {
//        homeMenuCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        eventCollectionView.frame = CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height)
    }

    func handleSignOut() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        self.present(loginViewController!, animated: true, completion: nil)
    }
    

}

