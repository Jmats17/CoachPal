//
//  MovesViewController.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/14/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class MovesViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var player : Player!
    var play = Play()
    let realm = try! Realm()
    var results : Results<Play>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        readTasksAndUpdateUI()

    }
    
    func readTasksAndUpdateUI(){
        
        results = realm.objects(Play)
        self.tableView.setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    
    @IBAction func addMove() {
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
                self.play.playName = (moveNameTextField?.text)!
                try! self.realm.write({ () -> Void in
                    assignedPlayer.plays.append(self.play)
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
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let play = self.results[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MoveCell

        let success = UITableViewRowAction(style: .Default, title: "Success") { action, index in
            try! self.realm.write({ () -> Void in
                play.totalPlaysDone += 1
                play.totalPlaysSuccess += 1
                play.successRate = (play.totalPlaysSuccess / play.totalPlaysDone)
                self.readTasksAndUpdateUI()
                print(self.play)
            })

        }
        success.backgroundColor = UIColor(red: 0/255, green: 204/255, blue: 102/255, alpha: 1.0)
        
        let fail = UITableViewRowAction(style: .Default, title: "Fail") { action, index in
            try! self.realm.write({  () -> Void in
                play.totalPlaysDone += 1
                play.successRate = (play.totalPlaysSuccess / play.totalPlaysDone)
                self.readTasksAndUpdateUI()
            })

        }
        fail.backgroundColor = UIColor(red: 242/255, green: 124/255, blue: 124/255, alpha: 1.0)
        
        return [success, fail]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results == nil {
            return 0
        }
        else {
            return results.count
        }
    }
    
    @IBAction func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MoveCell") as! MoveCell
        let play = self.results[indexPath.row]
        cell.moveLabel.text = play.playName
        cell.successLabel.text = "Success: \(String(format: "%.1f", (play.successRate * 100)))%"
        print(results)
        return cell
    }
    
}
