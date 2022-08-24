//
//  NotesConfigurator.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 24.08.22.
//

import UIKit

class NotesConfigurator {
    
    static func configure(vc: NotesViewController, path: String) {
        //interactor
        let interactor = NotesInteractor()
        vc.interactor = interactor
        
        //presenter
        let presenter = NotesPresenter()
        interactor.presenter = presenter
        presenter.viewController = vc
        
        //router
        let router = NotesRouter()
        vc.router = router
        router.viewController = vc
        
        //path
        vc.directoryPath = path
    }
}
