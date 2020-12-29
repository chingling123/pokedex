//
//  HTTPClient.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
