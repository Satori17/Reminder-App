//
//  NoteFileManager.swift
//  S.Kh_Task_25
//
//  Created by Saba Khitaridze on 23.08.22.
//

import UIKit

enum FileManagerError: Error {
    case filePathError
    case directoryExistError
    case noteExistError
    case encodingError
    case decodingError
}

class NoteFileManager {
    
    static let shared = NoteFileManager()
    
    private let manager = FileManager.default
    
    private var directoryUrl: URL? {
        try? manager.url(for: .applicationSupportDirectory,
                         in: .userDomainMask,
                         appropriateFor: nil,
                         create: false)
    }
    /*
     chose support directory depend on this info: https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html
     */
    
    //MARK: - Helper methods
    private func mainDirectory() throws -> URL {
        guard let mainDirectory = directoryUrl else {
            throw FileManagerError.filePathError
        }
        return mainDirectory
    }
    
    private func setupDate(onTime time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM, yyyy"
        let dateString = formatter.string(from: time)
        
        return dateString
    }
    
    //MARK: - Directories/Categories
    
    func addFileDirectory(withName name: String) throws {
        let dirName = try mainDirectory().appendingPathComponent(name)
        
        do {
            try manager.createDirectory(at: dirName, withIntermediateDirectories: true)
        } catch {
            throw FileManagerError.filePathError
        }
    }
    
    func getAllDirectories() throws -> [String] {
        do {
            let directories = try manager.contentsOfDirectory(at: mainDirectory(), includingPropertiesForKeys: nil)
            let categories = directories.map({ $0.lastPathComponent })
            
            return categories
        } catch {
            throw FileManagerError.filePathError
        }
    }
    
    func removeDirectory(atPath path: String) throws {
        let currentPath = directoryUrl?.appendingPathComponent(path)
        do {
            guard manager.fileExists(atPath: currentPath?.path ?? ""), let currentPath = currentPath else {
                throw FileManagerError.directoryExistError
            }
            try manager.removeItem(at: currentPath)
        } catch {
            throw FileManagerError.directoryExistError
        }
    }
    
    //MARK: - Notes
    
    func addNote(atPath path: String, onDate date: Date, withTitle title: String) throws {
        let notePath = try mainDirectory().appendingPathComponent(path).appendingPathComponent("\(title).json")
        let notesDictionary = ["title" : title, "date" : setupDate(onTime: date)]
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(notesDictionary) else { throw FileManagerError.encodingError }
        manager.createFile(atPath: notePath.path, contents: data)
    }
    
    
    func editNote(fromDirectory directory: String, atName: String, toName: String) {
        do {
            let notePath = try mainDirectory().appendingPathComponent(directory)
            
            let oldPath = notePath.appendingPathComponent("\(atName).json")
            let newPath = notePath.appendingPathComponent("\(toName).json")
            try manager.moveItem(at: oldPath, to: newPath)
        } catch {
            print(FileManagerError.filePathError)
        }
        
    }
    
    func getAllNotes(fromDirectory directory: String) throws -> [Note] {
        var noteArray = [Note]()
        guard var mainDirectory = directoryUrl else { throw FileManagerError.filePathError }
        mainDirectory.appendPathComponent(directory)
        let dirPath = try manager.contentsOfDirectory(at: mainDirectory, includingPropertiesForKeys: nil)
        let fetchedNotes = dirPath.filter({ $0.pathExtension == "json" })
        
        for aNote in fetchedNotes {
            do {
                let data = try Data(contentsOf: aNote)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Note.self, from: data)
                noteArray.append(decodedData)
            } catch {
                throw FileManagerError.decodingError
            }
        }
        
        return noteArray
    }
    
    func removeNote(fromDirectory directory: String, withName name: String) throws {
        let notePath = try mainDirectory().appendingPathComponent(directory).appendingPathComponent("\(name).json")
        
        do {
            try manager.removeItem(at: notePath)
        } catch {
            throw FileManagerError.noteExistError
        }
    }
    
}
