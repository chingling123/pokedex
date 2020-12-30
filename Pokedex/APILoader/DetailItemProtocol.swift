//
//  DetailItemProtocol.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import Foundation

public enum DetailItemResult{
    case success(DetailItem)
    case failure(Error)
}

protocol DetailItemProtocol {
    func load(completion: @escaping (DetailItemResult) -> Void)
}
