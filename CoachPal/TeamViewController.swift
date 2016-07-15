//
//  ViewController.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/9/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
class TeamViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    let realm = try! Realm()
    var team : Team? = nil
    var teams = [Team]()
    var results : Results<Team>!
    func readTasksAndUpdateUI(){
        
        results = realm.objects(Team)
        self.tableView.setEditing(false, animated: true)
        self.tableView.reloadData()
    }

    @IBAction func addTeam() {
        var teamNameTextField : UITextField?
        let alertController = UIAlertController(title: "Add Team", message: "Add your team name below", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            teamNameTextField = textField
            teamNameTextField?.placeholder = "South Golden Hawks"
            teamNameTextField?.autocapitalizationType = .Words
        }
        let okAction = UIAlertAction(title: "Add", style: .Default) { (action) in
            if teamNameTextField?.text != "" {
                let team = Team()
                team.teamName = (teamNameTextField?.text)!
                self.teams.append(team)
                try! self.realm.write({ () -> Void in
                    self.realm.add(self.teams)
                    self.readTasksAndUpdateUI()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        readTasksAndUpdateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let team = self.results[indexPath.row]
        
        let delete = UITableViewRowAction(style: .Default, title: "Delete") { action, index in
            try! self.realm.write({ () -> Void in
               self.realm.delete(team)
                self.readTasksAndUpdateUI()
                print(self.teams)
            })
            
        }
        delete.backgroundColor = UIColor(red: 242/255, green: 124/255, blue: 124/255, alpha: 1.0)
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let selectedTeam = results[indexPath.row]
        team = selectedTeam
        
        self.performSegueWithIdentifier("teamtoroster", sender: self)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "teamtoroster") {
            
            let rosterViewController = segue.destinationViewController as! RosterViewController
            rosterViewController.team = team
            
            
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results.count == 0 {
            return 0
        }
        else {
            return results.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell") as! TeamCell
        let team = results[indexPath.row]
        
        cell.teamName.text = team.teamName
            
        return cell
        
    }
}

