//
//  ResourceList.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import Foundation

public struct List: Equatable {
    var count: Int
    var next: URL?
    var previous: URL?
    var results: [Item]?
}


public struct Item: Equatable {
    var name: String
    var url: URL
}
