//
//  EventContainerCell.swift
//  fanspole
//
//  Created by Hardik on 27/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import UIKit
import RealmSwift

class EventContainerCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    let eventCellId = "eventCellId"
    var events: Results<Event>?
    var eventType: String?
    
    var datasource: String?{
        didSet{
            guard let event = datasource else { return }
            self.eventType = event
            setupViews()
        }
    }
    lazy var realm = try! Realm()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupViews() {
        print(self.eventType)
        ApiService.sharedInstance.fetchEvents { () in
            self.events = self.realm.objects(Event.self)
            self.eventCollectionView.reloadData()
        }
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let eventsCount = events?.count {
            return eventsCount
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellId, for: indexPath) as! EventCell
        cell.datasourceEvent = events?[indexPath.row]
        cell.leaderboardButton.tag = (events?[indexPath.row].id)!
        cell.backgroundColor = UIColor(red: 31/255, green: 51/255, blue: 71/255, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 20, height: 190)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
