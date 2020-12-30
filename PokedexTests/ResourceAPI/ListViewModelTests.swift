//
//  ListViewModelTests.swift
//  PokedexTests
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import XCTest
@testable import Pokedex

class ListViewModelTests: XCTestCase {
    
    var exp: XCTestExpectation?
    
    func test_ListItemsNil() {
        let sut = ListViewModel()
        
        XCTAssertTrue(sut.listItems().isEmpty)
    }
    
    func test_ListItemsSomeValues() {
        let sut = ListViewModel()
        sut.delegate = self
        
        trackForMemoryLeaks(sut)
        
        self.exp = expectation(description: "Wait for completion")
        sut.loadList()
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertNotNil(sut.listItems())
    }
    
    func test_CallNextPage() {
        let sut = ListViewModel()
        sut.delegate = self
        
        self.exp = expectation(description: "Wait for completion")
        sut.loadList()
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertNotNil(sut.listItems())
        
        self.exp = expectation(description: "Wait for completion")
        let count = sut.listItems().count
        
        sut.loadNextPage()
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertTrue(sut.listItems().count > count)
        
    }
    
    //MARK: Helpers
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance not deallocated. Potential memory leak", file: file, line: line)
        }
    }
    
}

extension ListViewModelTests: ListViewModelDelegate {
    func didLoad(indexes: [IndexPath]?) {
        self.exp?.fulfill()
        self.exp = nil
    }
    
    func didnLoad() {
        self.exp?.fulfill()
        self.exp = nil
    }
}
