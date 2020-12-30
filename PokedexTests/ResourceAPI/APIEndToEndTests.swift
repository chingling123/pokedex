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
        switch getFeedResult() {
        case let .success(items)?:
            XCTAssertEqual(items.results?.count, 20)
        case let .failure(error)?:
            XCTFail("Expected success, got \(error)")
        default:
            XCTFail("Expected success, got no irems")
        }
    }
    
    //MARK: Helpers
    
    private func getFeedResult(file: StaticString = #file, line: UInt = #line) -> ResourceItemResult? {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        let client = URLSessionHTTPClient()
        let loader = RemoteResourceLoader(url: url, client: client)
        
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        var receivedResult: ResourceItemResult?
        
        loader.load { resutl in
            receivedResult = resutl
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        return receivedResult
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance not deallocated. Potential memory leak", file: file, line: line)
        }
    }
}
