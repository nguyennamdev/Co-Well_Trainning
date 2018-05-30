//
//  ChampionsViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChampionsViewController: UIViewController {
    
    let cellId = "cellId"
    var ref: DatabaseReference!
    var champions:[Champion] = [Champion]()
    let championSelected:IndexPath =  IndexPath()
    var championDelegate:ChampionDelegate?
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var championsCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        setupChampionsCollectionView()
        
        activityIndicatorView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeChampions()
    }
    
    // MARK:- Private instance methods
    private func setupChampionsCollectionView(){
        championsCollectionView.delegate = self
        championsCollectionView.dataSource = self
        championsCollectionView.register(ChampionCollectionCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func observeChampions(){
        // show actitityIndicatorView
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ref.child("champions").observe(.value) { (snapshot) in
            let childrenSnapShot = snapshot.children.allObjects as! [DataSnapshot]
            for children in childrenSnapShot {
                let value = children.value as! [String: Any]
                let name = value["name"]
                let imageUrl = value["imageUrl"]
                let champion = Champion(imageUrl: imageUrl as! String, name: name as! String)
                self.champions.append(champion)
            }
            
            DispatchQueue.main.async {
                print(self.champions.count)
                self.championsCollectionView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                // hide activity
                self.activityIndicatorView.stopAnimating()
                self.activityIndicatorView.isHidden = true
            }
        }
    }
    
    // MARK:- Actions
    
    @IBAction func dismissSelf(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- Implement UICollectionViewDataSource
extension ChampionsViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return champions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChampionCollectionCell
        cell?.champion = self.champions[indexPath.row]
        return cell!
    }
    
}
// MARK:- Implement UICollectionViewDelegate
extension ChampionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let champion = champions[indexPath.row]
        championDelegate?.selectedChampion(champion: champion)
        dismiss(animated: true, completion: nil)
    }
    
}
// MARK:- Implement UICollectionViewDelegateFlowLayout
extension ChampionsViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
    
}









