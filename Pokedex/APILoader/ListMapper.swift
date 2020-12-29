//
//  ListMapper.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import Foundation

final class ListMapper {
    
    private static let OK_200: Int = 200
    
    static func map(_ data: Data, response: HTTPURLResponse) -> RemoteResourceLoader.Result {
        guard response.statusCode == OK_200,
              let list = try? JSONDecoder().decode(List.self, from: data) else {
            return .failure(RemoteResourceLoader.Error.invalidData)
        }
        
        return .success(list)
    }
}
