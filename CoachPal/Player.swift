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
    dynamic var name : String? = nil
    dynamic var age : String? = nil
    dynamic var wins : String? = nil
    dynamic var losses : String? = nil
    var plays = List<Play>()
    dynamic var height : String? = nil
    dynamic var weight : String? = nil
    dynamic var profilePicture : NSData? = nil
}