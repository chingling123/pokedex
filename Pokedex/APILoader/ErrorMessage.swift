//
//  ErrorMessage.swift
//  Pokedex
//
//  Created by Erik Eduardo do Nascimento on 30/12/20.
//

import Foundation
import UIKit

class ErrorMessage {
    static func show(msg: String, viewC: UIViewController) {
        let uiA = UIAlertController(title: "Erro", message: msg, preferredStyle: .alert)
        uiA.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        
        viewC.present(uiA, animated: true, completion: nil)
    }
}
