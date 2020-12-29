//
//  ResourceList.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import Foundation

public struct List: Equatable, Decodable {
    public let count: Int
    public let next: URL?
    public let previous: URL?
    public let results: [Item]?
    
    public init(count: Int, next: URL?, previous: URL?, results: [Item]?) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}


public struct Item: Equatable, Decodable {
    public let name: String
    public let url: URL
    
    public init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}
