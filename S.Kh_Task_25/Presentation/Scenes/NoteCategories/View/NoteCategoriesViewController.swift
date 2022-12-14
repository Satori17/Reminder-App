//
//  NoteCategoriesViewController.swift
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

protocol NoteCategoriesDisplayLogic: AnyObject {
    func display(categories: [String])
    func didFailDisplayCategories(withError: FileManagerError)
}

class NoteCategoriesViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var noteCategoriesTableView: UITableView!
    
    //MARK: - Vars
    
    var interactor: NoteCategoriesBusinessLogic?
    var router: NoteCategoriesRoutingLogic?
    var categoryNames = [String]()
    var isNotificationEnabled = true
    
    // MARK: View lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NoteCategoriesConfigurator.configure(vc: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //registering cell
        noteCategoriesTableView.registerNib(class: CategoryCell.self)
        fetchNoteCategories()
        isNotificationEnabled ? print("Access Granted") : AlertManager.shared.notificationDeniedAlert(onVC: self, withMessage: "Please, enable Notifications in the Settings app to receive reminder notifications")
    }
    
    //MARK: - IBAction
    
    @IBAction func addCategoryBtnPressed(_ sender: UIBarButtonItem) {
        AlertManager.shared.AddAlert(onVC: self, title: .category, message: "customize notes by category", placeholder: .category) { categoryName in
            do {
                try self.addCategory(withName: categoryName)
            } catch {
                AlertManager.shared.errorAlert(onVC: self, withMessage: "Error. Please, try again")
            }
        }
    }
    
    //MARK: - Methods
    
    private func fetchNoteCategories() {
        interactor?.fetchCategories()
    }
    
    private func addCategory(withName name: String) throws {
        do {
            try NoteFileManager.shared.addFileDirectory(withName: name)
            self.categoryNames = try NoteFileManager.shared.getAllDirectories()
            noteCategoriesTableView.reloadData()
        } catch {
            AlertManager.shared.errorAlert(onVC: self, withMessage: "Error. Please, try again")
        }
    }
    
}

//MARK: - Display Logic Protocol

extension NoteCategoriesViewController: NoteCategoriesDisplayLogic {
    
    func display(categories: [String]) {
        categoryNames = categories
    }
    
    func didFailDisplayCategories(withError: FileManagerError) {
        print(withError)
    }
    
}

//MARK: - TableView Delegate & DataSource

extension NoteCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCell
        let currentCategory = categoryNames[indexPath.row]
        cell.categoryNameLabel.text = currentCategory
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToNotes(withPath: categoryNames[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let path = categoryNames[indexPath.row]
            do {
                try NoteFileManager.shared.removeDirectory(atPath: path)
                self.categoryNames.remove(at: indexPath.row)
                self.noteCategoriesTableView.reloadData()
            } catch {
                AlertManager.shared.errorAlert(onVC: self, withMessage: "Couldn't remove category")
            }
        }
    }
    
}
