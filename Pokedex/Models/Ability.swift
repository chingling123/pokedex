//
//  Ability.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import Foundation

public struct Ability: Equatable, Decodable {
    public let name: String
    public let url: URL
}

public struct Abilities: Equatable, Decodable {
    public let ability: Ability
    public let is_hidden: Bool
    public let slot: Int
}
