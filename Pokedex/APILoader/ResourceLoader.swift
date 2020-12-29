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

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteResourceLoader {
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.get(from: url)
    }
}
