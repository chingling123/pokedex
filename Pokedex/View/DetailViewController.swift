//
//  DetailViewController.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import UIKit

class DetailViewController: UIViewController {

    private var PokeItem: Item
    private lazy var loadLabel: UILabel = {
            let l = UILabel()
            l.isHidden = true
            l.backgroundColor = .white
            l.text = "Carregando..."
            l.textAlignment = .center
            l.translatesAutoresizingMaskIntoConstraints = false
            return l
        }()
    private lazy var pokeImage: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.clipsToBounds = true
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    private lazy var stackV: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 30
        v.distribution = .equalSpacing
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private lazy var scroll: UIScrollView = {
        let s = UIScrollView()
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewModel: DetailViewModel
    
    weak var coordinator: ApplicationCoordinator?
    
    init(item: Item) {
        self.PokeItem = item
        self.viewModel = DetailViewModel(url: item.url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.Setup()
        self.viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.loadDetail()
        self.loadLabel.isHidden = false
    }
    
    private func doDetailsSetup(detail: DetailItem) {
        if let hasImageUrl = detail.sprites.front_default {
            self.pokeImage.load(url: hasImageUrl)
        } else if let hasImageUrl = detail.sprites.back_default {
            self.pokeImage.load(url: hasImageUrl)
        }
        
        self.stackV.addArrangedSubview(self.pokeImage)
        
        let id = UILabel()
        id.text = "Id: \(detail.id)"
        self.stackV.addArrangedSubview(id)
        
        let xpLabel = UILabel()
        xpLabel.text = "Base Experience: \(detail.base_experience)"
        self.stackV.addArrangedSubview(xpLabel)
        
        let heightLabel = UILabel()
        heightLabel.text = "Height: \(detail.height)"
        self.stackV.addArrangedSubview(heightLabel)
        
        let weight = UILabel()
        weight.text = "Weight: \(detail.weight)"
        self.stackV.addArrangedSubview(weight)
        
        let order = UILabel()
        order.text = "Order: \(detail.order)"
        self.stackV.addArrangedSubview(order)
        
        self.createAbilities(items: detail.abilities)
    }
    
    private func createAbilities(items: [Abilities]) {
        
        let act = UILabel()
        act.text = "Abilities:"
        self.stackV.addArrangedSubview(act)
        
        items.forEach { (ab) in
            let label = UILabel()
            label.text = ab.ability.name
            
            self.stackV.addArrangedSubview(label)
        }
    }

}

extension DetailViewController: DetailViewModelDelegate {
    func didLoad(data: DetailItem) {
        self.loadLabel.isHidden = true
        self.doDetailsSetup(detail: data)
    }
    
    func didnLoad() {
        ErrorMessage.show(msg: "Erro ao carregar dados", viewC: self)
        self.loadLabel.isHidden = true
    }
}

extension DetailViewController: ViewCodeProtocol {
    func CreateHierarchy() {
        self.view.addSubview(self.scroll)
        self.scroll.addSubview(self.contentView)
        self.contentView.addSubview(self.stackV)
        self.view.addSubview(self.loadLabel)
    }
    
    func CreateConstraints() {
        self.scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.scroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

        self.contentView.leadingAnchor.constraint(equalTo: self.scroll.leadingAnchor).isActive = true
        self.contentView.topAnchor.constraint(equalTo: self.scroll.topAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.scroll.trailingAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.scroll.bottomAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true

        self.stackV.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20.0).isActive = true
        self.stackV.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20.0).isActive = true
        self.stackV.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20.0).isActive = true
        self.stackV.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 20.0).isActive = true
    
        self.loadLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0).isActive = true
        self.loadLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 20.0).isActive = true
        self.loadLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0).isActive = true
    }
    
    func ConfigureViews() {
        self.view.backgroundColor = .white
        self.title = self.PokeItem.name.uppercased()
        
        self.scroll.contentSize = self.view.bounds.size
    }
}
