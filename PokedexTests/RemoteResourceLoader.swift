//
//  RemoteResourceLoader.swift
//  PokedexTests
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import XCTest
import Pokedex

class RemoteResourceLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        
        let (sut, client) = makeSUT(url: url)
        client.error = NSError(domain: "Test", code: 0)
        
        var capturedError: RemoteResourceLoader.Error?
        
        sut.load { error in capturedError = error }
        
        XCTAssertEqual(capturedError, .connectivity)
        
        
    }
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://test.com")!) -> (sut: RemoteResourceLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut =  RemoteResourceLoader(url: url, client: client)
        
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: Error?
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
        }
    }
}
