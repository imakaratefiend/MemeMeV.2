//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Bradley Hill on 9/8/17.
//  Copyright © 2017 Bradley Hill. All rights reserved.
//

import UIKit

//Mark: - MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

class MemeTableViewController: UITableViewController {
    
    @IBOutlet weak var memeTableView: UITableView!
    
    var meme: Meme!
    
//    override func viewDidLoad() {
        
//        super.viewDidLoad()
        
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //Mark: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell =  memeTableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        let cell =  tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        
        let meme = (UIApplication.shared.delegate as! AppDelegate).memes[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(meme.topTextField)" + " " + "\(meme.bottomTextField)"
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memes = (UIApplication.shared.delegate as! AppDelegate).memes
        
        let detailVC = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
        
        detailVC.meme = memes[(indexPath as NSIndexPath).row]
        
        navigationController!.pushViewController(detailVC, animated: true)
        
    }
    
}

