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
    
    @IBOutlet var tableViewTeams : UITableView!
    let realm = try! Realm()
    var team : Team? = nil
    var teams = [Team]()
    var results : Results<Team>!

    func readTasksAndUpdateUI(){
        
        results = realm.objects(Team.self)
        self.tableViewTeams.setEditing(false, animated: true)
        self.tableViewTeams.reloadData()

    }

    @IBAction func addTeam() {
        var teamNameTextField : UITextField?
        let alertController = UIAlertController(title: "Add Team", message: "Add your team name below", preferredStyle: .alert)
        alertController.addTextField { (textField) -> Void in
            teamNameTextField = textField
            teamNameTextField?.placeholder = "South Golden Hawks"
            teamNameTextField?.autocapitalizationType = .words
        }
        let okAction = UIAlertAction(title: "Add", style: .default) { (action) in
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel pressed")
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewTeams.delegate = self
        tableViewTeams.dataSource = self
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        readTasksAndUpdateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
            let team = self.results[indexPath.row]
            
            let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
                try! self.realm.write({ () -> Void in
                    self.realm.delete(team)
                    self.readTasksAndUpdateUI()
                    print(self.teams)
                })
                
            }
            delete.backgroundColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
            
            return [delete]
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1

        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
            return "Teams"
            
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        header.textLabel!.textColor = UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1.0)
        header.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
    }
  
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let selectedTeam = results[indexPath.row]
            team = selectedTeam
            
            self.performSegue(withIdentifier: "teamtoroster", sender: self)
            

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "teamtoroster") {
            
            let rosterViewController = segue.destination as! RosterViewController
            rosterViewController.team = team
            
            
        }

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            if results.count == 0 {
                return 0
            }
            else {
                return results.count
            }
       
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableViewTeams.dequeueReusableCell(withIdentifier: "TeamCell") as! TeamCell
            let team = results[indexPath.row]
            
            cell.teamName.text = team.teamName
            cell.teamSize.text = "\(team.teamList.count) wrestlers"
            return cell

       
    }
}

