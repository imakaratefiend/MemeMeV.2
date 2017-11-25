//
//  MemeDetailVC.swift
//  MemeMe
//
//  Created by Bradley Hill on 10/17/17.
//  Copyright © 2017 Bradley Hill. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    
    
    var meme: Meme?
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        memeImageView.image = meme?.memedImage
        memeImageView.contentMode = .scaleAspectFit
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
}
