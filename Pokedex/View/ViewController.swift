//
//  ViewController.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 29/12/20.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    var tableview = UITableView()
    
    private lazy var loadLabel: UILabel = {
            let l = UILabel()
            l.isHidden = true
            l.backgroundColor = .white
            l.text = "Carregando..."
            l.textAlignment = .center
            l.translatesAutoresizingMaskIntoConstraints = false
            return l
        }()
    
    private let cellIdentifier = "pokedexCell"
    
    let viewModel = ListViewModel()
    
    weak var coordinator: ApplicationCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.Setup()
        self.viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.loadList()
    }

}

extension ViewController: ViewCodeProtocol {
    func CreateHierarchy() {
        self.view.addSubview(tableview)
        self.view.addSubview(loadLabel)
    }
    
    func CreateConstraints() {
        self.tableview.translatesAutoresizingMaskIntoConstraints = false
        self.tableview.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
        self.tableview.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
        self.tableview.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0.0).isActive = true
        self.tableview.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0.0).isActive = true
        
        self.loadLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        self.loadLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        self.loadLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
    }
    
    func ConfigureViews() {
        self.view.backgroundColor = .white
        self.title = "Pokedex"
        
        self.tableview.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableview.delegate = self
        self.tableview.dataSource = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.listItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableview.dequeueReusableCell(withIdentifier: cellIdentifier) {
            
            let hasItem = self.viewModel.getItem(at: indexPath.row)
            cell.textLabel?.text = hasItem.name
            cell.imageView?.image = UIImage(named: "icon")
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let hasItems = self.viewModel.listItems()
        if indexPath.row == (hasItems.count - 1) {
            self.loadLabel.isHidden = false
            self.viewModel.loadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hasItem = self.viewModel.getItem(at: indexPath.row)
        self.coordinator?.showDetail(item: hasItem)
    }
}

extension ViewController: ListViewModelDelegate {
    func didLoad(indexes: [IndexPath]?) {
        guard let hasIndexes = indexes else {
            self.loadLabel.isHidden = true
            self.tableview.reloadData()
            return
        }
        
        self.tableview.beginUpdates()
        self.tableview.insertRows(at: hasIndexes, with: .automatic)
        self.tableview.endUpdates()
        self.loadLabel.isHidden = true
    }
    
    func didnLoad() {
        
    }
}
