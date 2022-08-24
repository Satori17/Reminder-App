//
//  AlertManager.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 24.08.22.
//

import UIKit

enum AlertType: String {
    case category = "Add Category"
    case note = "Add Note"
}

class AlertManager {
    
    static let shared = AlertManager()
    private var vc = UIViewController()
    
    
    func AddAlert(onVC vc: UIViewController, title: AlertType, message: String?, placeholder: AlertType, handler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title.rawValue, message: message, preferredStyle: .alert)
        //textField
        alert.addTextField { textField in
            textField.placeholder = "Type \(placeholder)"
        }
        //save
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            guard let textField = alert.textFields?[0],
                  let categoryName = textField.text,
                  textField.hasText else {
                self.errorAlert(onVC: vc, withMessage: "Please Type any \(title)")
                return
            }
            handler(categoryName)
        }))
        //cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.present(alert, animated: true)
    }
    
    func errorAlert(onVC vc: UIViewController, withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        vc.present(alert, animated: true)
    }
    
}
