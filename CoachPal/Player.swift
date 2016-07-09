//
//  Player.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/9/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

struct Player {
    var name = ""
    var age : Int? = nil
    var wins : Int? = nil
    var losses : Int? = nil
    var plays = [Play]()
    var height = "5'10"
    var weight = 135
}