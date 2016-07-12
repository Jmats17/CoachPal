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

class PlayerViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var player : Player!
    @IBOutlet var nameAndAgeLabel : UILabel!
    @IBOutlet var weightAndHeightLabel : UILabel!
    @IBOutlet var recordLabel : UILabel!
    @IBOutlet var tableView : UITableView!
    
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
                weightAndHeightLabel.text = "\(weight) / \(height)"
            }
            else {
                weightAndHeightLabel.text = "\(weight) / Height: ??"

            }
        }
        else {
            if let height = player.height {
                weightAndHeightLabel.text = "Weight: ?? / \(height)"

            }
            else {
                weightAndHeightLabel.text = "Weight: ?? / Height: ??"
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadPlayerInfo()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell") as! PlayerCell
        return cell
    }
    
    
    
    
    
    
}