//
//  Coordinator.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import UIKit

protocol Coordinator {
    var navBar: UINavigationController { get set }
    func start()
}
