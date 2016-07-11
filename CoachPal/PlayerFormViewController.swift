//
//  PlayerFormViewController.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/11/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

class PlayerFormViewController : FormViewController {
    
    var player = Player()
    var team : Team!
    var realm = try! Realm()
    
    override func viewDidLoad() {
        createForm()
        team = Data.sharedInstance.team
    }
    
    func createForm() {
        
        let form = FormDescriptor(title: "Player")
        form.title = "Add Player"
        let basicInfoSection = FormSectionDescriptor(headerTitle: "Player info", footerTitle: nil)
        
        let nameRow = FormRowDescriptor(tag: "Name", type: .Name, title: "Name:")
        basicInfoSection.rows.append(nameRow)
        
        let ageRow = FormRowDescriptor(tag: "Age", type: .Number, title: "Age:")
        basicInfoSection.rows.append(ageRow)
        
        let weightRow = FormRowDescriptor(tag: "Weight", type: .Number, title: "Weight:")
        basicInfoSection.rows.append(weightRow)
        
        let heightRow = FormRowDescriptor(tag: "Height", type: .Text, title: "Height:")
        basicInfoSection.rows.append(heightRow)
        
        let recordInfoSection = FormSectionDescriptor(headerTitle: "Record Info", footerTitle: nil)
        
        let winsRow = FormRowDescriptor(tag: "Wins", type: .Number, title: "Wins:")
        recordInfoSection.rows.append(winsRow)
        
        let lossesRow = FormRowDescriptor(tag: "Losses", type: .Number, title: "Losses:")
        recordInfoSection.rows.append(lossesRow)
        
        let submitSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        let submitRow = FormRowDescriptor(tag: "Submit", type: .Button, title: "Submit")
        submitRow.configuration.button.didSelectClosure = { _ in
            if let playerName = (nameRow.value as? String) {
                self.player.name = playerName
            }
            
            if let playerAge = (ageRow.value as? Int) {
                self.player.age = playerAge
            }
            
            if let playerWeight = (weightRow.value as? Double) {
                self.player.weight = playerWeight
            }
            
            if let playerHeight = (heightRow.value as? String) {
                self.player.height = playerHeight
            }
            
            if let playerWins = (winsRow.value as? Int) {
                self.player.wins = playerWins
            }
            
            if let playerLosses = (lossesRow.value as? Int) {
                self.player.losses = playerLosses
            }
            
            self.team.teamList.append(self.player)
           // print(self.team)
            
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        
        
        submitSection.rows.append(submitRow)
        
        form.sections = [basicInfoSection, recordInfoSection, submitSection]
        self.form = form
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC:RosterViewController = segue.destinationViewController as! RosterViewController
        
        //set properties on the destination view controller
        destinationVC.team = team
        destinationVC.player = player
    }
    
}
