//
//  APIEndToEndTests.swift
//  PokedexTests
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import XCTest
import Pokedex

class APIEndToEndTests: XCTestCase {
    
    func test_EndToEndGet() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        let client = URLSessionHTTPClient()
        let loader = RemoteResourceLoader(url: url, client: client)
        
        let exp = expectation(description: "Wait for load completion")
        var receivedResult: ResourceItemResult?
        
        loader.load { resutl in
            receivedResult = resutl
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        
        switch receivedResult {
        case let .success(items)?:
            XCTAssertEqual(items.results?.count, 20)
        case let .failure(error)?:
            XCTFail("Expected success, got \(error)")
        default:
            XCTFail("Expected success, got no irems")
        }
    }
}
