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

class Player : Object {
    dynamic var name : String = ""
    dynamic var age : Int = 0
    dynamic var wins : Int = 0
    dynamic var losses : Int = 0
    var plays = List<Play>()
    dynamic var height : String = "5'10"
    dynamic var weight : Double = 0.0
}