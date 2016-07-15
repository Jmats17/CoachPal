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

class PlayerFormViewController : FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var player = Player()
    var team : Team!
    var realm = try! Realm()
    let picker = UIImagePickerController()
    var imageData : NSData?
    var cameFromPlayer : Bool!
    
    override func viewDidLoad() {
        picker.delegate = self
        createFormIfNew()
        team = Data.sharedInstance.team
        cameFromPlayer = Data.sharedInstance.cameFromPlayer
        if cameFromPlayer == true {
            player = Data.sharedInstance.player!
            editForm(player)
        }
        else {
            createFormIfNew()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        let ogImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let data : NSData = UIImagePNGRepresentation(ogImage!)!
        imageData = data
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editForm(player : Player) {
        let form = FormDescriptor(title: "\(player.name)")
        form.title = "Edit \(player.name) Info"
        let basicInfoSection = FormSectionDescriptor(headerTitle: "\(player.name) info", footerTitle: nil)
        
        let nameRow = FormRowDescriptor(tag: "Name", type: .Name, title: "Name:")
        basicInfoSection.rows.append(nameRow)
        nameRow.configuration.cell.appearance = ["textField.placeholder" : "Justin Matsnev", "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        if let playerName = player.name {
            nameRow.value = playerName
        }
        else {
            nameRow.value = nil
        }
        let ageRow = FormRowDescriptor(tag: "Age", type: .Number, title: "Age:")
        basicInfoSection.rows.append(ageRow)
        ageRow.configuration.cell.appearance = ["textField.placeholder" : "18", "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        if let playerAge = player.age {
            ageRow.value = playerAge
        }
        else {
            ageRow.value = nil
        }
        let weightRow = FormRowDescriptor(tag: "Weight", type: .Number, title: "Weight:")
        basicInfoSection.rows.append(weightRow)
        weightRow.configuration.cell.appearance = ["textField.placeholder" : "135", "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        if let playerWeight = player.weight {
            weightRow.value = playerWeight
        }
        else {
            weightRow.value = nil
        }
        let heightRow = FormRowDescriptor(tag: "Height", type: .Text, title: "Height:")
        basicInfoSection.rows.append(heightRow)
        heightRow.configuration.cell.appearance = ["textField.placeholder" : "5'10", "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        if let playerHeight = player.height {
            heightRow.value = playerHeight
        }
        else {
            heightRow.value = nil
        }
        let picSection = FormSectionDescriptor(headerTitle: "Player Picture", footerTitle: nil)
        
        let picRow = FormRowDescriptor(tag: "Image", type: .Button, title: "Select Profile Picture")
        picRow.configuration.button.didSelectClosure = { _ in
            
            let pictureMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
            
            let choosePhoto = UIAlertAction(title: "Photo Album", style: .Default, handler: { (alert : UIAlertAction) in
                self.picker.allowsEditing = false
                self.picker.sourceType = .PhotoLibrary
                self.presentViewController(self.picker, animated: true, completion: nil)
            })
            
            let takePhoto = UIAlertAction(title: "Camera", style: .Default, handler: { (alert : UIAlertAction) in
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerControllerSourceType.Camera
                self.picker.cameraCaptureMode = .Photo
                self.picker.modalPresentationStyle = .FullScreen
                self.presentViewController(self.picker, animated: true, completion: nil)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert : UIAlertAction) in
                
            })
            
            pictureMenu.addAction(choosePhoto)
            pictureMenu.addAction(takePhoto)
            pictureMenu.addAction(cancel)
            
            self.presentViewController(pictureMenu, animated: true, completion: nil)
            
        }
        if let playerPic = player.profilePicture {
            picRow.value = playerPic
        }
        else {
            picRow.value = nil
        }
        picSection.rows.append(picRow)
        
        let recordInfoSection = FormSectionDescriptor(headerTitle: "Record Info", footerTitle: nil)
        
        let winsRow = FormRowDescriptor(tag: "Wins", type: .Number, title: "Wins:")
        recordInfoSection.rows.append(winsRow)
        winsRow.configuration.cell.appearance = ["textField.placeholder" : "10", "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        if let playerWins = player.wins {
            winsRow.value = playerWins
        }
        else {
            winsRow.value = nil
        }
        let lossesRow = FormRowDescriptor(tag: "Losses", type: .Number, title: "Losses:")
        recordInfoSection.rows.append(lossesRow)
        lossesRow.configuration.cell.appearance = ["textField.placeholder" : "0", "textField.textAlignment" : NSTextAlignment.Left.rawValue]
        if let playerLosses = player.losses {
            lossesRow.value = playerLosses
        }
        else {
            lossesRow.value = nil
        }
        let submitSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        let submitRow = FormRowDescriptor(tag: "Submit", type: .Button, title: "Add")
        submitRow.configuration.button.didSelectClosure = { _ in
            
            if let playerName = (nameRow.value as? String) {
                try! self.realm.write({
                    
                    self.player.name = playerName
                })
            }
            else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            if let playerAge = (ageRow.value as? String) {
                try! self.realm.write({
                    
                    self.player.age = playerAge
                })
            }
            else {
                
            }
            
            if let playerWeight = (weightRow.value as? String) {
                try! self.realm.write({
                    
                    self.player.weight = playerWeight
                })
            }
            else {
            }
            
            if let playerHeight = (heightRow.value as? String) {
                try! self.realm.write({
                    
                    self.player.height = playerHeight
                })
            }
            else {
            }
            
            if let playerWins = (winsRow.value as? String) {
                try! self.realm.write({
                    
                    self.player.wins = playerWins
                })
            }
            else {
            }
            
            if let playerLosses = (lossesRow.value as? String)  {
                try! self.realm.write({
                    
                    self.player.losses = playerLosses
                })
            }
            else {
            }
            if self.imageData != nil {
                try! self.realm.write({
                    
                    self.player.profilePicture = self.imageData
                })
            }
            else {
            }
            
           self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        submitSection.rows.append(submitRow)

        let cancelRow = FormRowDescriptor(tag: "Cancel", type: .Button, title: "Cancel")
        cancelRow.configuration.button.didSelectClosure = { _ in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        submitSection.rows.append(cancelRow)
        
        form.sections = [basicInfoSection, picSection ,recordInfoSection, submitSection]
        self.form = form
    }
    
    
    func createFormIfNew() {
        
        let form = FormDescriptor(title: "Player")
        form.title = "Add Player"
        let basicInfoSection = FormSectionDescriptor(headerTitle: "Player info", footerTitle: nil)
        
        let nameRow = FormRowDescriptor(tag: "Name", type: .Name, title: "Name:")
        basicInfoSection.rows.append(nameRow)
        nameRow.configuration.cell.appearance = ["textField.placeholder" : "Justin Matsnev", "textField.textAlignment" : NSTextAlignment.Left.rawValue]

        let ageRow = FormRowDescriptor(tag: "Age", type: .Number, title: "Age:")
        basicInfoSection.rows.append(ageRow)
        ageRow.configuration.cell.appearance = ["textField.placeholder" : "18", "textField.textAlignment" : NSTextAlignment.Left.rawValue]

        let weightRow = FormRowDescriptor(tag: "Weight", type: .Number, title: "Weight:")
        basicInfoSection.rows.append(weightRow)
        weightRow.configuration.cell.appearance = ["textField.placeholder" : "135", "textField.textAlignment" : NSTextAlignment.Left.rawValue]

        let heightRow = FormRowDescriptor(tag: "Height", type: .Text, title: "Height:")
        basicInfoSection.rows.append(heightRow)
        heightRow.configuration.cell.appearance = ["textField.placeholder" : "5'10", "textField.textAlignment" : NSTextAlignment.Left.rawValue]

        let picSection = FormSectionDescriptor(headerTitle: "Player Picture", footerTitle: nil)
        
        let picRow = FormRowDescriptor(tag: "Image", type: .Button, title: "Select Profile Picture")
        picRow.configuration.button.didSelectClosure = { _ in
            
            let pictureMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
            
            let choosePhoto = UIAlertAction(title: "Photo Album", style: .Default, handler: { (alert : UIAlertAction) in
                self.picker.allowsEditing = false
                self.picker.sourceType = .PhotoLibrary
                self.presentViewController(self.picker, animated: true, completion: nil)
            })
            
            let takePhoto = UIAlertAction(title: "Camera", style: .Default, handler: { (alert : UIAlertAction) in
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerControllerSourceType.Camera
                self.picker.cameraCaptureMode = .Photo
                self.picker.modalPresentationStyle = .FullScreen
                self.presentViewController(self.picker, animated: true, completion: nil)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alert : UIAlertAction) in
                
            })
            
            pictureMenu.addAction(choosePhoto)
            pictureMenu.addAction(takePhoto)
            pictureMenu.addAction(cancel)
            
            self.presentViewController(pictureMenu, animated: true, completion: nil)
            
        }
        picSection.rows.append(picRow)
        
        let recordInfoSection = FormSectionDescriptor(headerTitle: "Record Info", footerTitle: nil)
        
        let winsRow = FormRowDescriptor(tag: "Wins", type: .Number, title: "Wins:")
        recordInfoSection.rows.append(winsRow)
        winsRow.configuration.cell.appearance = ["textField.placeholder" : "10", "textField.textAlignment" : NSTextAlignment.Left.rawValue]

        let lossesRow = FormRowDescriptor(tag: "Losses", type: .Number, title: "Losses:")
        recordInfoSection.rows.append(lossesRow)
        lossesRow.configuration.cell.appearance = ["textField.placeholder" : "0", "textField.textAlignment" : NSTextAlignment.Left.rawValue]

        let submitSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        let submitRow = FormRowDescriptor(tag: "Submit", type: .Button, title: "Add")
        submitRow.configuration.button.didSelectClosure = { _ in
           
            if let playerName = (nameRow.value as? String) {
                self.player.name = playerName
                
            }
            else {
                
            }
            
            if let playerAge = (ageRow.value as? String) {
                self.player.age = playerAge
            }
            else {
                self.player.age = "0"
            }
            
            if let playerWeight = (weightRow.value as? String) {
                self.player.weight = playerWeight
            }
            else {
                 self.player.weight = "0"
            }
            
            if let playerHeight = (heightRow.value as? String) {
                self.player.height = playerHeight
            }
            else {
                self.player.height = "0'0"
            }
            
            if let playerWins = (winsRow.value as? String) {
                self.player.wins = playerWins
            }
            else {
                self.player.wins = "0"
            }
            
            if let playerLosses = (lossesRow.value as? String)  {
                self.player.losses = playerLosses
            }
            else {
                self.player.losses = "0"
            }
            if self.imageData != nil {
                self.player.profilePicture = self.imageData
            }
            else {
                self.player.profilePicture = nil
            }
        
            if nameRow.value != nil {
                try! self.realm.write({
                    
                    self.team.teamList.append(self.player)
                    print(self.player)
                })
                self.dismissViewControllerAnimated(true, completion: nil)

            }
            else {
                self.dismissViewControllerAnimated(true, completion: nil)

            }
          
        }
        
        
        submitSection.rows.append(submitRow)
        
        let cancelRow = FormRowDescriptor(tag: "Cancel", type: .Button, title: "Cancel")
        cancelRow.configuration.button.didSelectClosure = { _ in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        submitSection.rows.append(cancelRow)
        form.sections = [basicInfoSection, picSection ,recordInfoSection, submitSection]
        self.form = form
    }
    
   
    
}
