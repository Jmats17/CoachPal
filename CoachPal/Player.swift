//
//  Player.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/9/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Eureka
import ImageRow

class Player : Object {
    dynamic var name : String!
    dynamic var age : String!
    dynamic var wins : String!
    dynamic var losses : String!
    var plays = List<Play>()
    dynamic var height : String!
    dynamic var weight : String!
    dynamic var profilePicture : NSData!

    convenience init(name : String, age : String, wins : String, losses : String, height : String, weight : String, profPic : NSData) {
        self.init()
        self.name = name
        self.age = age
        self.weight = weight
        self.height = height
        self.losses = losses
        self.wins = wins
        self.profilePicture = profPic
        
    }
    
    convenience init(form : Form, data : NSData?) {
        self.init()
        
        if let name = (form.rowBy(tag: "name") as! TextRow).value {
            self.name = name
        }
        else {
            self.name = nil
        }
        
        if let age = (form.rowBy(tag: "age") as! IntRow).value {
            self.age = String(age)
        }
        else {
            self.age = nil
        }
        
        if let weight = (form.rowBy(tag: "weight") as! IntRow).value {
            self.weight = String(weight)
        }
        else {
            self.weight = nil
        }
        
        if let height = (form.rowBy(tag: "height") as! TextRow).value {
            self.height = height
        }
        else {
            self.height = nil
        }
        
        if let wins = (form.rowBy(tag: "wins") as! IntRow).value {
            self.wins = String(wins)
        }
        else {
            self.wins = nil
        }
        
        if let losses = (form.rowBy(tag: "losses") as! IntRow).value {
            self.losses = String(losses)
        }
        else {
            self.losses = nil
        }
        
//        if let picData = data {
//            self.profilePicture = picData
//        }
//        else {
//            self.profilePicture = nil
//        }
    }
    
    
    
}
