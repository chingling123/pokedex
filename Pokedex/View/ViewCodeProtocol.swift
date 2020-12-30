//
//  ViewCodeProtocol.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import Foundation

protocol ViewCodeProtocol {
    func CreateHierarchy()
    func CreateConstraints()
    func ConfigureViews()
}

extension ViewCodeProtocol {
    func Setup() {
        CreateHierarchy()
        CreateConstraints()
        ConfigureViews()
    }
}
