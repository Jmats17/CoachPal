//
//  Play.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/9/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
class Play : Object {
    dynamic var playName = ""
    dynamic var totalPlaysDone = 0.0
    dynamic var totalPlaysSuccess = 0.0
    dynamic var successRate = 0.0
}