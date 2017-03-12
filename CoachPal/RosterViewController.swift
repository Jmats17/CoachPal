//
//  RosterViewController.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/9/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Realm


class RosterViewController : UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var navTitle : UINavigationItem!
    @IBOutlet var tableView : UITableView!
    var team : Team!
    let realm = try! Realm()
    var player : Player? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let retrievedTeam = team {
             navTitle.title = "\(retrievedTeam.teamName)"
        }
        else {
            navTitle.title = "Team Roster"

        }
        
    }
 
    
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @IBAction func addPlayer() {
        Data.sharedInstance.team = team
        self.present(PlayerFormViewController(), animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if team.teamList.isEmpty {
            return 0
        }
        else {
            return team.teamList.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlayer = team.teamList[indexPath.row]
        player = selectedPlayer
        
        self.performSegue(withIdentifier: "rostertoplayer", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "rostertoplayer") {
            let playerViewController = segue.destination as! PlayerViewController
            playerViewController.player = player
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unknownValue = "??"
        let cell = tableView.dequeueReusableCell(withIdentifier: "RosterCell") as! RosterCell
        
        let player = team.teamList[indexPath.row]
        if let playerName = player.name {
            cell.player.text = playerName

        }
        let playerWeight = player.weight ?? unknownValue
//        if let playerProfPic = player.profilePicture {
//            let image = UIImage(data: (playerProfPic) as Data)
//            cell.playerPic.image = image
//        }
//        else {
            cell.playerPic.image = nil
//        }
        let playerHeight = player.height ?? unknownValue
        let playerWins = player.wins ?? unknownValue
        let playerLosses = player.losses ?? unknownValue
        
        cell.weightHeightRecord.text = "Wins: \(playerWins) - Losses: \(playerLosses)"
        + "\nWeight: \(playerWeight)lb / Height: \(playerHeight)"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deletedPlayer = team.teamList[indexPath.row]
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            try! self.realm.write({ () -> Void in
                print(deletedPlayer)
                print(deletedPlayer.plays)
                self.realm.delete(deletedPlayer.plays)
                self.realm.delete(deletedPlayer)
                self.tableView.reloadData()
                print(self.team.teamList)
            })
            
        }
        delete.backgroundColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
        header.textLabel!.textColor = UIColor(red: 171/255, green: 171/255, blue: 171/255, alpha: 1.0)
        header.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Players"
        
        
    }
    
    
}
