//
//  FlavorsViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/27/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import UIKit

class FlavorsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flavor : String?
    
    let flavorLabels: [String] = [
    "Regular",
    "Peach",
    "Coffee",
    "Green Tea",
    "Strawberry",
    "Jasmine",
    "Thai",
    "Honeydew",
    "Taro",
    "Almond",
    "Chocolate",
    "Lychee",
    "Black Tea",
    "Oolong",
    "Passion Fruit",
    "Hazelnut",
    "Mango",
    "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.collectionView.delegate = self
//        self.collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

}


extension FlavorsViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostThumbImageCell", for: indexPath) as! PostThumbImageCell
        
        let flavorImages: [UIImage] = [
            UIImage(named: "Regular")!,
            UIImage(named: "Peach")!,
            UIImage(named: "Coffee")!,
            UIImage(named: "Green Tea")!,
            UIImage(named: "Strawberry")!,
            UIImage(named: "Jasmine")!,
            UIImage(named: "Thai")!,
            UIImage(named: "Honeydew")!,
            UIImage(named: "Taro")!,
            UIImage(named: "Almond")!,
            UIImage(named: "Chocolate")!,
            UIImage(named: "Lychee")!, 
            UIImage(named: "Black Tea")!,
            UIImage(named: "Oolong")!,
            UIImage(named: "Passion Fruit")!,
            UIImage(named: "Hazelnut")!,
            UIImage(named: "Mango")!,
            UIImage(named: "Other")!]
        
        let image = flavorImages[indexPath.row]
        cell.flavorImage.image = image
        
        let drinks = flavorLabels[indexPath.row]
        cell.drinkName.text = drinks
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath)!
        flavor = flavorLabels[indexPath.item]
        print("FLA: \(flavor)")
        performSegue(withIdentifier: "onSelect", sender: currentCell)
       
    }
    
}

extension FlavorsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    
}

