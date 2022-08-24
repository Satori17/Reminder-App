//
//  UITableView+Extension.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 23.08.22.
//

import UIKit

extension UITableViewCell {
    static var identifier: String { String(describing: self) }
    static var nibFile: UINib { UINib(nibName: identifier, bundle: nil) }
}

extension UITableView {
    func registerNib<T: UITableViewCell>(class: T.Type) {
        self.register(T.nibFile, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier,
                                                  for: indexPath) as? Cell else {
            fatalError("Error happened for cell id: \(identifier) at \(indexPath))")
        }
        return cell
    }
}
