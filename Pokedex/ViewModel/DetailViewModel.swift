//
//  DetailViewModel.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import Foundation
import UIKit

protocol DetailViewModelDelegate: class {
    func didLoad(data: DetailItem)
    func didnLoad()
}

class DetailViewModel {
    private let url: URL
    private let client = URLSessionHTTPClient()
    private var loader: DetailItemLoader?
    
    weak var delegate: DetailViewModelDelegate?
    
    init(url: URL) {
        self.url = url
        self.loader = DetailItemLoader(url: url, client: client)
    }
    
    func loadDetail() {
        loader?.load { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.delegate?.didLoad(data: detail)
                case .failure:
                    self?.delegate?.didnLoad()
                }
            }
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
