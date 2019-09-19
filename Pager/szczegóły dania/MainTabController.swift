//
//  MainTabController.swift
//  Pager
//
//  Created by darys on 09.01.2018.
//  Copyright © 2018 darys. All rights reserved.
//

import Foundation
import UIKit

class MainTabController: UITabBarController {
    
    var memory: [Memorydb]? = []        //id dania zapamiętane w bazie lokalnej
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //białe ikony jeśli sa niewybrane
        self.tabBar.unselectedItemTintColor = UIColor.white
        
        //== pobranie id dania i ścieżki do foto i alergeny z tabeli 'memory'
        memory = StephencelisDB.instance.getMemory(memo: "mem_danie") //a:id dania, b:imageName, c: alergeny
        
        self.navigationItem.title = self.memory![0].d
    }
    
}
