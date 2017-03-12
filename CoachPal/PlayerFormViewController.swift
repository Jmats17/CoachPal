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
import Eureka
import ImageRow

class PlayerFormViewController : FormViewController, UINavigationControllerDelegate {
    
    var player : Player!
    var team : Team!
    var realm = try! Realm()
    var imageData : NSData?
    var cameFromPlayer : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        team = Data.sharedInstance.team
        cameFromPlayer = Data.sharedInstance.cameFromPlayer
        if cameFromPlayer == true {
            player = Data.sharedInstance.player!
            editForm(player)
        }
        else {
            createForm()
        }
    }
    
    func createForm() {
        form +++ Section("Basic Information")
            <<< TextRow() { row in
                row.title = "Name"
                row.placeholder = "John Doe"
                row.tag = "name"
            }
            <<< IntRow() { row in
                row.title = "Age"
                row.placeholder = "18"
                row.tag = "age"
            }
            <<< IntRow() { row in
                row.title = "Weight"
                row.placeholder = "150"
                row.tag = "weight"
            }
            <<< TextRow() { row in
                row.title = "Height"
                row.placeholder = "5\'11\""
                row.tag = "height"
            }
            +++ Section("Picture")
            <<< ImageRow() { row in
                row.title = "Select photo"
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
                row.clearAction = .yes(style: UIAlertActionStyle.destructive)
                row.tag = "pic"
            }
            +++ Section("Record")
            
            <<< IntRow() { row in
                row.title = "Wins"
                row.placeholder = "10"
                row.tag = "wins"
            }
            <<< IntRow() { row in
                row.title = "Losses"
                row.placeholder = "5"
                row.tag = "losses"
            }
            
            +++ Section("")
            <<< ButtonRow() { row in
                row.title = "Create"
                }.onCellSelection({ row in

                    if (self.form.rowBy(tag: "name") as! TextRow).value != nil {
                        let picRow: ImageRow? = self.form.rowBy(tag: "pic")
                        let picVal = picRow?.value
                        if let picture = picVal {
                            self.imageData = UIImagePNGRepresentation(picture) as NSData?
                        }
                        try! self.realm.write({
                            
                            let createdPlayer = Player(form: self.form, data : self.imageData)
                            self.team.teamList.append(createdPlayer)
                        })
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    else {
                        let alert = UIAlertController(title: "Uh Oh!", message: "You may be missing a field, check to make sure everything is filled in correctly.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                })
    }
    
    func editForm(_ player : Player) {
        form +++ Section("Basic Information")
            <<< TextRow() { row in
                row.title = "Name"
                row.placeholder = "John Doe"
                row.value = player.name
                row.tag = "name"
            }
            <<< IntRow() { row in
                row.title = "Age"
                row.placeholder = "18"
                if player.age != nil {
                    row.value = Int(string: player.age)
                }
                row.tag = "age"
            }
            <<< IntRow() { row in
                row.title = "Weight"
                row.placeholder = "150"
                if player.weight != nil {
                    row.value = Int(string: player.weight)
                }
                row.tag = "weight"
            }
            <<< TextRow() { row in
                row.title = "Height"
                if player.height != nil {
                    row.value = player.height
                }
                row.placeholder = "5\'11\""
                row.tag = "height"
            }
            +++ Section("Picture")
            <<< ImageRow() { row in
                row.title = "Select photo"
                //row.value = UIImage(data: player.profilePicture as! Data)
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
                row.clearAction = .yes(style: UIAlertActionStyle.destructive)
                row.tag = "pic"
            }
            +++ Section("Record")
            
            <<< IntRow() { row in
                row.title = "Wins"
                if player.wins != nil {
                    row.value = Int(string: player.wins)
                }
                row.placeholder = "10"
                row.tag = "wins"
            }
            <<< IntRow() { row in
                row.title = "Losses"
                if player.losses != nil {
                    row.value = Int(string: player.losses)
                }
                row.placeholder = "5"
                row.tag = "losses"
            }
            
            +++ Section("")
            <<< ButtonRow() { row in
                row.title = "Create"
                }.onCellSelection({ row in
                    if (self.form.rowBy(tag: "name") as! TextRow).value != nil {
                        let picRow: ImageRow? = self.form.rowBy(tag: "pic")
                        let ageRow: IntRow? = self.form.rowBy(tag: "age")
                        let weightRow: IntRow? = self.form.rowBy(tag: "weight")
                        let heightRow: TextRow? = self.form.rowBy(tag: "height")
                        let winsRow: IntRow? = self.form.rowBy(tag: "wins")
                        let lossesRow: IntRow? = self.form.rowBy(tag: "losses")

                        let picVal = picRow?.value
                        if let picture = picVal {
                            self.imageData = UIImagePNGRepresentation(picture) as NSData?
                        }

                        try! self.realm.write({
                            if let age = (ageRow?.value) {
                                self.player.age = String(age)
                            }
                            if let weight = (weightRow?.value) {
                                self.player.weight = String(weight)
                            }
                            if let height = (heightRow?.value) {
                                self.player.height = height
                            }
                            if let wins = (winsRow?.value) {
                                self.player.wins = String(wins)
                            }
                            if let losses = (lossesRow?.value) {
                                self.player.losses = String(losses)
                            }
                        })
                        self.dismiss(animated: true, completion: nil)
                        
                    }

                    else {
                        let alert = UIAlertController(title: "Uh Oh!", message: "You may be missing a field, check to make sure everything is filled in correctly.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                })
    }
   

}
//
//    func editForm(_ player : Player) {
//        let form = FormDescriptor(title: "\(player.name)")
//        form.title = "Edit \(player.name) Info"
//        let basicInfoSection = FormSectionDescriptor(headerTitle: "\(player.name) info", footerTitle: nil)
//
//        let nameRow = FormRowDescriptor(tag: "Name", type: .name, title: "Name:")
//        basicInfoSection.rows.append(nameRow)
//        nameRow.configuration.cell.appearance = ["textField.placeholder" : "Justin Matsnev", "textField.textAlignment" : NSTextAlignment.left.rawValue]
//        if let playerName = player.name {
//            nameRow.value = playerName
//        }
//        else {
//            nameRow.value = nil
//        }
//        let ageRow = FormRowDescriptor(tag: "Age", type: .number, title: "Age:")
//        basicInfoSection.rows.append(ageRow)
//        ageRow.configuration.cell.appearance = ["textField.placeholder" : "18", "textField.textAlignment" : NSTextAlignment.left.rawValue]
//        if let playerAge = player.age {
//            ageRow.value = playerAge
//        }
//        else {
//            ageRow.value = nil
//        }
//        let weightRow = FormRowDescriptor(tag: "Weight", type: .number, title: "Weight:")
//        basicInfoSection.rows.append(weightRow)
//        weightRow.configuration.cell.appearance = ["textField.placeholder" : "135", "textField.textAlignment" : NSTextAlignment.left.rawValue]
//        if let playerWeight = player.weight {
//            weightRow.value = playerWeight
//        }
//        else {
//            weightRow.value = nil
//        }
//        let heightRow = FormRowDescriptor(tag: "Height", type: .text, title: "Height:")
//        basicInfoSection.rows.append(heightRow)
//        heightRow.configuration.cell.appearance = ["textField.placeholder" : "5'10", "textField.textAlignment" : NSTextAlignment.left.rawValue]
//        if let playerHeight = player.height {
//            heightRow.value = playerHeight
//        }
//        else {
//            heightRow.value = nil
//        }
//        let picSection = FormSectionDescriptor(headerTitle: "Player Picture", footerTitle: nil)
//
//        let picRow = FormRowDescriptor(tag: "Image", type: .button, title: "Select Profile Picture")
//        picRow.configuration.button.didSelectClosure = { _ in
//
//            let pictureMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
//
//            let choosePhoto = UIAlertAction(title: "Photo Album", style: .default, handler: { (alert : UIAlertAction) in
//                self.picker.allowsEditing = false
//                self.picker.sourceType = .photoLibrary
//                self.present(self.picker, animated: true, completion: nil)
//            })
//
//            let takePhoto = UIAlertAction(title: "Camera", style: .default, handler: { (alert : UIAlertAction) in
//                self.picker.allowsEditing = false
//                self.picker.sourceType = UIImagePickerControllerSourceType.camera
//                self.picker.cameraCaptureMode = .photo
//                self.picker.modalPresentationStyle = .fullScreen
//                self.present(self.picker, animated: true, completion: nil)
//            })
//
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert : UIAlertAction) in
//
//            })
//
//            pictureMenu.addAction(choosePhoto)
//            pictureMenu.addAction(takePhoto)
//            pictureMenu.addAction(cancel)
//
//            self.present(pictureMenu, animated: true, completion: nil)
//
//        }
//        if let playerPic = player.profilePicture {
//            picRow.value = playerPic
//        }
//        else {
//            picRow.value = nil
//        }
//        picSection.rows.append(picRow)
//
//        let recordInfoSection = FormSectionDescriptor(headerTitle: "Record Info", footerTitle: nil)
//
//        let winsRow = FormRowDescriptor(tag: "Wins", type: .number, title: "Wins:")
//        recordInfoSection.rows.append(winsRow)
//        winsRow.configuration.cell.appearance = ["textField.placeholder" : "10", "textField.textAlignment" : NSTextAlignment.left.rawValue]
//        if let playerWins = player.wins {
//            winsRow.value = playerWins
//        }
//        else {
//            winsRow.value = nil
//        }
//        let lossesRow = FormRowDescriptor(tag: "Losses", type: .number, title: "Losses:")
//        recordInfoSection.rows.append(lossesRow)
//        lossesRow.configuration.cell.appearance = ["textField.placeholder" : "0", "textField.textAlignment" : NSTextAlignment.left.rawValue]
//        if let playerLosses = player.losses {
//            lossesRow.value = playerLosses
//        }
//        else {
//            lossesRow.value = nil
//        }
//        let submitSection = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
//
//        let submitRow = FormRowDescriptor(tag: "Submit", type: .button, title: "Add")
//        submitRow.configuration.button.didSelectClosure = { _ in
//
//            if let playerName = (nameRow.value as? String) {
//                try! self.realm.write({
//
//                    self.player.name = playerName
//                })
//            }
//            else {
//                self.dismiss(animated: true, completion: nil)
//            }
//
//            if let playerAge = (ageRow.value as? String) {
//                try! self.realm.write({
//
//                    self.player.age = playerAge
//                })
//            }
//            else {
//
//            }
//
//            if let playerWeight = (weightRow.value as? String) {
//                try! self.realm.write({
//
//                    self.player.weight = playerWeight
//                })
//            }
//            else {
//            }
//
//            if let playerHeight = (heightRow.value as? String) {
//                try! self.realm.write({
//
//                    self.player.height = playerHeight
//                })
//            }
//            else {
//            }
//
//            if let playerWins = (winsRow.value as? String) {
//                try! self.realm.write({
//
//                    self.player.wins = playerWins
//                })
//            }
//            else {
//            }
//
//            if let playerLosses = (lossesRow.value as? String)  {
//                try! self.realm.write({
//
//                    self.player.losses = playerLosses
//                })
//            }
//            else {
//            }
//            if self.imageData != nil {
//                try! self.realm.write({
//
//                    self.player.profilePicture = self.imageData
//                })
//            }
//            else {
//            }
//
//           self.dismiss(animated: true, completion: nil)
//
//        }
//        submitSection.rows.append(submitRow)
//
//        let cancelRow = FormRowDescriptor(tag: "Cancel", type: .button, title: "Cancel")
//        cancelRow.configuration.button.didSelectClosure = { _ in
//            self.dismiss(animated: true, completion: nil)
//        }
//        submitSection.rows.append(cancelRow)
//
//        form.sections = [basicInfoSection, picSection ,recordInfoSection, submitSection]
//        self.form = form
//    }
//
//

