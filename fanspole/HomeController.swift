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
    
    let cellId = "eventCellId"
    var events: Results<Event>?
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
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let eventsCount = events?.count {
            return eventsCount
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCell
        cell.datasourceEvent = events?[indexPath.row]
//        cell.datasourceEvent = events[indexPath.row]
//        To send match ID directly in tag
//        cell.leaderboardButton.tag = events[indexPath.row].id
//        to send index of event object
        cell.leaderboardButton.tag = indexPath.row
        cell.backgroundColor = UIColor(red: 31/255, green: 51/255, blue: 71/255, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 190)
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
        eventCollectionView.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: view.frame.height)
    }

    func handleSignOut() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        self.present(loginViewController!, animated: true, completion: nil)
    }
    

}

