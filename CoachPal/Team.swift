//
//  Team.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/9/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Team : Object {
   dynamic var teamName = ""
   var teamList = List<Player>()
    
}
