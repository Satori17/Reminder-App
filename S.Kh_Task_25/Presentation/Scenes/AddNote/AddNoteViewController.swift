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
    @IBOutlet weak var saveReminderBtn: UIButton! {
        didSet {
            saveReminderBtn.layer.cornerRadius = 10
        }
    }
    
    //MARK: - Vars
    
    var directoryPath: String?
    var currentNote: NoteViewModel?
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
        //check if we're editing or adding note
        if let currentNote = currentNote {
            editHelper(path: directoryPath, currentTitle: currentNote.noteTitle, newTitle: noteText, date: noteDatePicker.date)
        } else {
            saveHelper(path: directoryPath, date: noteDatePicker.date, title: noteText)
        }
        NotificationManager.shared.createNotification(withName: noteText, duration: noteDatePicker.date)
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
    
    private func editHelper(path: String, currentTitle: String, newTitle: String, date: Date) {
        do {
            try NoteFileManager.shared.editNote(fromDirectory: path, atName: currentTitle, toName: newTitle, onDate: date)
        } catch {
            AlertManager.shared.errorAlert(onVC: self, withMessage: "Couldn't edit note")
        }
    }
    
}
