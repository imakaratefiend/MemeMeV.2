//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Bradley Hill on 9/8/17.
//  Copyright © 2017 Bradley Hill. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CollectionViewController: UICollectionViewController

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    var collectionMemes: [Meme] = []
    var collectionMemes: Meme!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // The following code/solution was gleaned from the Udacity Forums for the logic.
        
        let space: CGFloat = 1.5
        let dimension = view.frame.size.width >= view.frame.size.height ? (view.frame.size.width - (2 * space)) / 6.0 : (view.frame.size.width - (2 * space)) / 3.0
        
        collectionFlowLayout.minimumInteritemSpacing = 0.5
        collectionFlowLayout.minimumLineSpacing = 0.5
        collectionFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = (UIApplication.shared.delegate as! AppDelegate).memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.memeCollectionView.image = meme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {

        let memes = (UIApplication.shared.delegate as! AppDelegate).memes
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailController, animated: true)
        
    }
}
