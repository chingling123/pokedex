//
//  ResourceList.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import Foundation

struct List {
    var count: Int
    var next: URL?
    var previous: URL?
    var results: [Item]?
}


struct Item {
    var name: String
    var url: URL
}
