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
    
    @IBOutlet var tableView : UITableView!
    var team : Team!
    let realm = try! Realm()
    var player : Player?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print(team)
        print(player)
    }
    

    
    @IBAction func refresh() {
        self.tableView.reloadData()
        print(team)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    @IBAction func addPlayer() {
        Data.sharedInstance.team = team
        self.presentViewController(PlayerFormViewController(), animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RosterCell") as! RosterCell
        
        let player = team.teamList[indexPath.row]
        
        cell.player.text = player.name
        cell.weight.text = "\(player.weight) lb"
        
        return cell
    }
    
}