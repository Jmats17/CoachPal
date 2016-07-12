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
    
    override func viewDidLoad() {
        picker.delegate = self
        createForm()
        team = Data.sharedInstance.team
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
        
        let lossesRow = FormRowDescriptor(tag: "Losses", type: .Number, title: "Losses:")
        recordInfoSection.rows.append(lossesRow)
        
        let submitSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        let submitRow = FormRowDescriptor(tag: "Submit", type: .Button, title: "Submit")
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
                self.dismissViewControllerAnimated(false, completion: nil)

            }
            else {
                self.dismissViewControllerAnimated(false, completion: nil)

            }
          
        }
        
        
        submitSection.rows.append(submitRow)
        
        form.sections = [basicInfoSection, picSection ,recordInfoSection, submitSection]
        self.form = form
    }
    
   
    
}
