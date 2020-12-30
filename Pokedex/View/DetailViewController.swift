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
    
    weak var coordinator: ApplicationCoordinator?
    
    init(item: Item) {
        self.PokeItem = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.Setup()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: ViewCodeProtocol {
    func CreateHierarchy() {
        
    }
    
    func CreateConstraints() {
        self.loadLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0).isActive = true
        self.loadLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0).isActive = true
        self.loadLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
    }
    
    func ConfigureViews() {
        self.view.backgroundColor = .white
        self.title = self.PokeItem.name.uppercased()
    }
}
