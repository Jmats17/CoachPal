//
//  PlayerViewController.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/12/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class PlayerViewController : UIViewController {
    
    var player : Player!
    @IBOutlet var nameAndAgeLabel : UILabel!
    @IBOutlet var weightAndHeightLabel : UILabel!
    @IBOutlet var recordLabel : UILabel!
    @IBOutlet var profileImage : UIImageView!
    
    func loadPlayerInfo() {
        if let name = player.name  {
            if let age = player.age {
                nameAndAgeLabel.text = "\(name), \(age)"

            }
            else {
                nameAndAgeLabel.text = "\(player.name), Age: ??"

            }
        }
        if let weight = player.weight {
            if let height = player.height {
                weightAndHeightLabel.text = "\(weight) lb / \(height)"
            }
            else {
                weightAndHeightLabel.text = "\(weight) lb / Height: ??"

            }
        }
        else {
            if let height = player.height {
                weightAndHeightLabel.text = "Weight: ?? lb / \(height)"

            }
            else {
                weightAndHeightLabel.text = "Weight: ?? lb / Height: ??"
            }
        }
        if let wins = player.wins {
            if let losses = player.losses {
                recordLabel.text = "Wins: \(wins) - Losses: \(losses)"
            }
            else {
                recordLabel.text = "Wins: \(wins) - Losses: ??"
            }
        }
        else {
            if let losses = player.losses {
                recordLabel.text = "Wins: ?? - Losses: \(losses)"

            }
            else {
                recordLabel.text = "Wins: ?? - Losses: ??"

            }
        }
        if let profImage = player.profilePicture {
            
            profileImage.image = UIImage(data: profImage)
        }
        else {
            profileImage.image = profileImage.image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPlayerInfo()
        profileImage.layer.cornerRadius =  profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
    }
  
    @IBAction func edit() {
        Data.sharedInstance.cameFromPlayer = true
        Data.sharedInstance.player = player
        self.presentViewController(PlayerFormViewController(), animated: true, completion: nil)
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
      //  self.performSegueWithIdentifier("playertoroster", sender: self)
    }
    
    
    
    
}