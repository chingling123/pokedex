//
//  ResourceItemProtocol.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import Foundation

public enum ResourceItemResult{
    case success(List)
    case failure(Error)
}

protocol ResourceItem {
    func load(completion: @escaping (ResourceItemResult) -> Void)
}
