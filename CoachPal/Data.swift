//
//  Data.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/10/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

class Data {
    var team:Team? = nil
    var player:Player? = nil
    var cameFromPlayer : Bool? = false
    var recentPlayersArray : [Player]? = nil
    static let sharedInstance = Data()
}