//
//  ResourceLoader.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import Foundation

enum ResourceLoaderResult {
    case success(List)
    case error(Error)
}

protocol ResourceLoader {
    func load(completion: @escaping (ResourceLoaderResult) -> Void)
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteResourceLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success(List)
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success(let data, let response):
                if let list = try? ListMapper.map(data, response) {
                    completion(.success(list))
                } else {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

private class ListMapper {
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> List {
        guard response.statusCode == 200 else {
            throw RemoteResourceLoader.Error.invalidData
        }
        
        return try JSONDecoder().decode(List.self, from: data)
    }
}
