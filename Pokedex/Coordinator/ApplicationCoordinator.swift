//
//  ApplicationCoordinator.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import Foundation
import UIKit

class ApplicationCoordinator: Coordinator {
    var navBar: UINavigationController
    
    init(nav: UINavigationController) {
        self.navBar = nav
    }
    
    func start() {
        let vc = ViewController()
        vc.coordinator = self
        self.navBar.pushViewController(vc, animated: true)
    }
    
}
