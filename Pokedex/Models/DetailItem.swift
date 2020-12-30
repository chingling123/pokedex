//
//  DetailItem.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import Foundation

public struct DetailItem: Equatable, Decodable {
    public let abilities: [Ability]
    public let base_experience: Int
    public let height: Int
    public let id: Int
    public let is_default: Bool
    public let name: String
    public let order: Int
    public let weight: Int
    public let sprites: Sprites
}
