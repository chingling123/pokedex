//
//  ListViewModel.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import Foundation

protocol ListViewModelDelegate: class {
    func didLoad(indexes: [IndexPath]?)
    func didnLoad()
}

class ListViewModel {
    private var list = [Item]()
    private var nextPage: URL?
    
    private let url = URL(string: "https://pokeapi.co/api/v2/pokemon")!
    private let client = URLSessionHTTPClient()
    private var loader: RemoteResourceLoader?
    
    weak var delegate: ListViewModelDelegate?
    
    init() {
        self.loader = RemoteResourceLoader(url: url, client: client)
    }
    
    func loadList() {
        loader?.load { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self?.checkData(list: list)
                case .failure:
                    self?.delegate?.didnLoad()
                }
            }
        }
    }
    
    func loadNextPage() {
        guard let hasNextP = self.nextPage else { return }
        print(hasNextP.absoluteURL)
        self.loader = RemoteResourceLoader(url: hasNextP, client: client)
        self.loadList()
    }
    
    func listItems() -> [Item] {
        return self.list
    }
    
    func getItem(at index: Int) -> Item {
        return self.list[index]
    }
    
    private func checkData(list: List) {
        if (list.next != nil) {
            self.nextPage = list.next
        }
        
        guard let hasItems = list.results else { return }
        self.list.append(contentsOf: hasItems)
        
        let indexes = self.calculateIndexes(newItens: hasItems)
        self.delegate?.didLoad(indexes: indexes)
    }
    
    private func calculateIndexes(newItens: [Item]) -> [IndexPath] {
        let startIdx = self.list.count - newItens.count
        let endIdx = startIdx + newItens.count
        return (startIdx..<endIdx).map {IndexPath(row: $0, section: 0)}
    }
}
