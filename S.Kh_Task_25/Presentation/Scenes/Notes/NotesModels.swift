//
//  NotesModels.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 24.08.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

typealias NoteViewModel = NoteModel.ViewModel.DisplayedNotes

enum NoteModel {
    
    struct Response {
        let notes: [Note]
    }
    
    struct ViewModel {
        let displayedNotes: [DisplayedNotes]
        
        struct DisplayedNotes {
            let noteTitle: String
            let noteDate: String
            
        }
    }
    
}
