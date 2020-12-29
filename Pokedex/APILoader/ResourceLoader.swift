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
    case sucess(HTTPURLResponse)
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
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .sucess:
                completion(.invalidData)
            case .failure:
                completion(.connectivity)
            }
        }
    }
}
