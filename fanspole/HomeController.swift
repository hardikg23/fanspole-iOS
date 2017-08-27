//
//  FirstViewController.swift
//  fanspole
//
//  Created by Hardik on 20/08/17.
//  Copyright © 2017 Fanspole. All rights reserved.
//

import UIKit
//import RealmSwift

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var eventContainerCollectionView: UICollectionView!
//    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var homeMenuCollectionView: UICollectionView!
    
    let eventContainerCellId = "eventContainerCellId"
    let homeMenuCellId = "homeMenuCellId"
    let menuItem = ["Upcoming", "Live", "Results"]
//    lazy var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // print("Realm Path \(Realm.Configuration.defaultConfiguration.fileURL!)")
        setUpNavigationBar()
        setupHorizontalBar()
        setUpCollectionView()
    }
    
    private func setUpNavigationBar() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleSignOut))
    }
    
    private func setUpCollectionView(){
        homeMenuCollectionView.backgroundColor = UIColor(red: 31/255, green: 51/255, blue: 71/255, alpha: 1)
        self.eventContainerCollectionView.delegate = self
        self.eventContainerCollectionView.dataSource = self
        self.homeMenuCollectionView.delegate = self
        self.homeMenuCollectionView.dataSource = self
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
    
    func scrollToMenuIndex(_ menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        eventContainerCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.homeMenuCollectionView {
            self.scrollToMenuIndex(indexPath.item)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        homeMenuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.eventContainerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventContainerCellId, for: indexPath) as! EventContainerCell
            if indexPath.row == 0 {
                cell.datasource = "next"
            } else if indexPath.row == 1 {
                cell.datasource = "live"
            } else {
                cell.datasource = "prev"
            }
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
        if collectionView == self.eventContainerCollectionView {
            return CGSize(width: view.frame.width, height: view.frame.height - 120)
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
            if let matchId = (sender as AnyObject).tag {
                leaderboardVC.matchId = matchId
            }
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        homeMenuCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//        eventContainerCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//    }

    func handleSignOut() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginVC")
        self.present(loginViewController!, animated: true, completion: nil)
    }
    

}

