//
//  AddNoteViewController.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 24.08.22.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var noteDatePicker: UIDatePicker!
    @IBOutlet weak var saveNoteBtn: UIButton! {
        didSet {
            saveNoteBtn.layer.cornerRadius = 10
        }
    }
    
    //MARK: - Vars
    
    var directoryPath: String?
    var reloadNotesHandler: (() -> Void)?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBAction
    
    @IBAction func saveNote(_ sender: UIButton) {
        guard let directoryPath = directoryPath,
              let noteText = noteTextField.text,
              noteTextField.hasText else {
            AlertManager.shared.errorAlert(onVC: self, withMessage: "Please type note description")
            return
        }
        saveHelper(path: directoryPath, date: noteDatePicker.date, title: noteText)
        reloadNotesHandler?()
        self.dismiss(animated: true)
    }
    
    //MARK: - Methods
    
    private func saveHelper(path: String, date: Date, title: String) {
        do {
            try NoteFileManager.shared.addNote(atPath: path, onDate: date, withTitle: title)
        } catch {
            AlertManager.shared.errorAlert(onVC: self, withMessage: "Error. Please, try again")
        }
    }
    
}
