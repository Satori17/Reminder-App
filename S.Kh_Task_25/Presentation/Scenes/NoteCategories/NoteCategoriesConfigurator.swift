//
//  NoteCategoriesConfigurator.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 23.08.22.
//

import UIKit

class NoteCategoriesConfigurator {
    
    static func configure(vc: NoteCategoriesViewController) {
        //interactor
        let interactor = NoteCategoriesInteractor()
        vc.interactor = interactor
        
        //presenter
        let presenter = NoteCategoriesPresenter()
        interactor.presenter = presenter
        presenter.viewController = vc
        
        //router
        let router = NoteCategoriesRouter()
        vc.router = router
        router.viewController = vc
    }
}
