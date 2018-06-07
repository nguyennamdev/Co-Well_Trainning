//
//  ColorChatViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/7/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

private let cellId = "cellId"

class ColorChatViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    var colors:[UIColor]!
    var selectedColorClosure:((UIColor) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colors = [ #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.2608989198, green: 0.6994831856, blue: 0.6447243918, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
                   #colorLiteral(red: 0.7840141654, green: 0.4566069245, blue: 0.5285884142, alpha: 1), #colorLiteral(red: 0.1532526314, green: 0.4985974431, blue: 0.5746747851, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
                   #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.706476659, green: 0.6064013511, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),
                   #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1) ]
        
        titleLabel.text = "Custom your chat".localized
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // MARK: Actions
    
    @IBAction func closeSelf(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true, completion: nil)
    }
    
    
}
// MARK: UICollectionViewDataSource
extension ColorChatViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = self.colors[indexPath.row]
        cell.layer.cornerRadius = (collectionView.frame.width / 5) / 2
        cell.clipsToBounds = true
        return cell
    }
    
}
// MARK:- UICollectionViewDelegateFlowLayout
extension ColorChatViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.width / 5)
    }
    
}


// MARK:- UICollectionViewDelegate
extension ColorChatViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let colorSelected = self.colors[indexPath.row]
        self.selectedColorClosure?(colorSelected)
        dismiss(animated: true, completion: nil)
    }
    
}
