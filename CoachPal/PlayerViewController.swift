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

class PlayerViewController : UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var player : Player!
    let realm = try! Realm()
    @IBOutlet var navBar : UINavigationBar!
    @IBOutlet var nameAndAgeLabel : UILabel!
    @IBOutlet var weightAndHeightLabel : UILabel!
    @IBOutlet var winLabel : UILabel!
    @IBOutlet var lossLabel : UILabel!
    @IBOutlet var profileImage : UIImageView!
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
                winLabel.text = "\(wins)"
                lossLabel.text = "\(losses)"
            }
            else {
                winLabel.text = "\(wins)"
                lossLabel.text = "??"
            }
        }
        else {
            if let losses = player.losses {
                lossLabel.text = "\(losses)"
                winLabel.text = "??"
            }
            else {
                winLabel.text = "??"
                lossLabel.text = "??"
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
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        navBar.shadowImage = UIImage()
        // Sets the translucent background color
        navBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        navBar.translucent = true
        tableView.delegate = self
        tableView.dataSource = self
        navBar.topItem?.title = player.name!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if player.plays.count == 0 {
            return 0
        }
        else {
            return player.plays.count
        }
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MoveCell") as! MoveCell
        let play = self.player.plays[indexPath.row]
        cell.moveLabel.text = play.playName
        cell.successLabel.text = "Success: \(String(format: "%.1f", (play.successRate * 100)))%"
        print(player.plays)
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let play = self.player.plays[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MoveCell
        
        let success = UITableViewRowAction(style: .Default, title: "Success") { action, index in
            try! self.realm.write({ () -> Void in
                play.totalPlaysDone += 1
                play.totalPlaysSuccess += 1
                play.successRate = (play.totalPlaysSuccess / play.totalPlaysDone)
                self.readTasksAndUpdateUI()
                print(play)
            })
            
        }
        success.backgroundColor = UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1.0)
        
        let fail = UITableViewRowAction(style: .Default, title: "Fail") { action, index in
            try! self.realm.write({  () -> Void in
                play.totalPlaysDone += 1
                play.successRate = (play.totalPlaysSuccess / play.totalPlaysDone)
                self.readTasksAndUpdateUI()
            })
            
        }
        fail.backgroundColor = UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        
        return [success, fail]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func readTasksAndUpdateUI(){
        
        self.tableView.setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadPlayerInfo()
        readTasksAndUpdateUI()

    }
    
    @IBAction func addMove() {
        let play = Play()
        var moveNameTextField : UITextField?
        let alertController = UIAlertController(title: "", message: "Add Play/Move" , preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            moveNameTextField = textField
            moveNameTextField?.placeholder = "Double Leg Takedown"
            moveNameTextField?.autocapitalizationType = .Words
        }
        let okAction = UIAlertAction(title: "Add", style: .Default) { (action) in
            if moveNameTextField?.text != "" {
                let assignedPlayer = self.player
                play.playName = (moveNameTextField?.text)!
                try! self.realm.write({ () -> Void in
                    assignedPlayer.plays.append(play)
                    self.readTasksAndUpdateUI()
                    print(self.player.plays)
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print("cancel pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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