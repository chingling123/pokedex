//
//  ListMapper.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import Foundation

final class ListMapper {
    
    private static let OK_200: Int = 200
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> List {
        guard response.statusCode == OK_200 else {
            throw RemoteResourceLoader.Error.invalidData
        }
        
        return try JSONDecoder().decode(List.self, from: data)
    }
}
