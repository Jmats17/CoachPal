//
//  ViewController.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/9/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import UIKit

class TeamViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    var team = Team()
    var teams = [Team]()
    
    @IBAction func addTeam() {
        var teamNameTextField : UITextField?
        let alertController = UIAlertController(title: "Add Team", message: "Add your team name below", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            teamNameTextField = textField
            teamNameTextField?.placeholder = "South Golden Hawks"
        }
        let okAction = UIAlertAction(title: "Add", style: .Default) { (action) in
            print("Ok pressed")
            
            
            if let teamName = teamNameTextField?.text {
                
                self.team.teamName = teamName
                self.teams.append(self.team)
            }
            else {
                self.team.teamName = "Team"
                self.teams.append(self.team)
            }
            self.tableView.reloadData()
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if teams.count == 0 {
            return 0
        }
        else {
            return teams.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell") as! TeamCell
        var sortedTeam = teams.sort { $0.teamName < $1.teamName }

        let team = sortedTeam[indexPath.row]
        
        cell.teamName.text = team.teamName
        
        return cell
    }
}

