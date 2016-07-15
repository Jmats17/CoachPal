//
//  TabBarViewController.swift
//  CoachPal
//
//  Created by Justin Matsnev on 7/13/16.
//  Copyright © 2016 Justin Matsnev. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController : UITabBarController {
    
    var player : Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerViewController = self.viewControllers?.first as! PlayerViewController
        playerViewController.player = player
        
        let movesViewController = self.viewControllers?[1] as! MovesViewController
        movesViewController.player = player
    }
}