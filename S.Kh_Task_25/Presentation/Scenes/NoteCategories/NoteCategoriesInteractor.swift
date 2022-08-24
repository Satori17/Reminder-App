//
//  NoteCategoriesInteractor.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 23.08.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NoteCategoriesBusinessLogic {
  func fetchCategories()
}


class NoteCategoriesInteractor {
  var presenter: NoteCategoriesPresentationLogic?
  var worker: NoteCategoriesWorker?
 
}

extension NoteCategoriesInteractor: NoteCategoriesBusinessLogic {
    
    func fetchCategories() {
        worker = NoteCategoriesWorker()
        worker?.getCategories(completion: { result in
            switch result {
            case .success(let categories):
                let response = NoteCategory(categories: categories)
                self.presenter?.present(viewModel: response)
            case .failure(let error):
                self.presenter?.didFailPresentCategories(withError: error)
            }
        })
    }
    
}