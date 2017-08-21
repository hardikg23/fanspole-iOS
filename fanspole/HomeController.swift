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

protocol HomeControllerDelegate: class {
    func clickOnLeaderBoard(matchId: Int)
    func clickOnViewTeam(matchId: Int)
}

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    let cellId = "eventCellId"
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        Alamofire.request("http://localhost:3000/api/v2/users/cards",method: .get, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let eventsJsonArray = json["data"]["upcoming_matches"].array {
                    self.events = eventsJsonArray.map{Event(json: $0)}
                    self.eventCollectionView.reloadData()
                }
            case .failure(let error):
                print(error);
            }
        }
        self.eventCollectionView.delegate = self
        self.eventCollectionView.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCell
        cell.datasourceItem = events[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 190)
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

