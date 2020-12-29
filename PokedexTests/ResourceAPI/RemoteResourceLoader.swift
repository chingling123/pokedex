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
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        
        let (sut, client) = makeSUT(url: url)
        
        expect(sut, toCompleteWith: .failure(RemoteResourceLoader.Error.connectivity), when: {
        
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNonHTTP200() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
        
        let (sut, client) = makeSUT(url: url)
    
        let listJson = makeJson(items: [])
        
        [199, 201, 300, 400, 500].enumerated().forEach { (index, code) in
            
            expect(sut, toCompleteWith: .failure(RemoteResourceLoader.Error.invalidData), when: {
                client.complete(withStatusCode: code, data: listJson, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOnHTTP200WithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(RemoteResourceLoader.Error.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
        
    }
    
    func test_load_deliversNoItemsOnHTTP200EmptyJSONList() {
        let (sut, client) = makeSUT()
        
        let list = List(count: 1, next: nil, previous: nil, results: [])
        
        expect(sut, toCompleteWith: .success(list), when: {
            let emptyJSON = makeJson(items: [])
            client.complete(withStatusCode: 200, data: emptyJSON)
        })
    }
    
    func test_load_deliversItemsOnHTTP200WithJSON() {
        let (sut, client) = makeSUT()

        let item1 = Item(name: "poke1", url: URL(string: "https://a.com")!)
        let item1JSon = [
            "name": "poke1",
            "url": "https://a.com"
        ]
        let item2 = Item(name: "poke2", url: URL(string: "https://b.com")!)
        let item2JSon = [
            "name": "poke2",
            "url": "https://b.com"
        ]

        let list = List(count: 1, next: nil, previous: nil, results: [item1, item2])

        let listJson = makeJson(items: [item1JSon, item2JSon])

        expect(sut, toCompleteWith: .success(list), when: {
            client.complete(withStatusCode: 200, data: listJson)
        })
    }
    
    func test_load_doesNotDeliverResultAfterInstanceHasBeenDeallocated() {
        let url = URL(string: "http:s.com")!
        let client = HTTPClientSpy()
        var sut: RemoteResourceLoader? = RemoteResourceLoader(url: url, client: client)
        
        var capturedResults = [RemoteResourceLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        
        client.complete(withStatusCode: 200, data: makeJson(items: []))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://test.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteResourceLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut =  RemoteResourceLoader(url: url, client: client)
        
        addTeardownBlock { [weak sut, weak client] in
            XCTAssertNil(client, "Instance not deallocated. Potential memory leak.", file: file, line: line)
            XCTAssertNil(sut, "Instance not deallocated. Potential memory leak.", file: file, line: line)
        }
        
        return (sut, client)
    }
    
    private func makeJson(items: [[String: Any]]) -> Data {
        let listJson = [
            "count": 1,
            "results": items
        ] as [String : Any]
        
        return try! JSONSerialization.data(withJSONObject: listJson, options: .prettyPrinted)
    }
    
    private func expect(_ sut: RemoteResourceLoader, toCompleteWith result: RemoteResourceLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "wait for completion")
        
        sut.load { receivedResult in
            switch (receivedResult, result) {
            case let (.success(receivedItems), .success(expectedITems)):
                XCTAssertEqual(receivedItems, expectedITems, file: file, line: line)
            case let (.failure(receivedError as RemoteResourceLoader.Error), .failure(expectedError as RemoteResourceLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default :
                XCTFail("Expected result \(result) got \(receivedResult)", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) ->Void)]()
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
