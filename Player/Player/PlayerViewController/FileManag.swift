//
//  FileManag.swift
//  Player
//
//  Created by pavel mishanin on 19.09.2022.
//

import UIKit

protocol IFileManag: AnyObject {
    func AllFilesFromDirectory() -> [String]
    func fileExist(atPath: String) -> Bool
    func moveItem(at: URL, to: URL)
    func appendingPathComponent(_ string: String) -> URL
}

final class FileManag {
    
    private let fileManager = FileManager.default
    
    private var documentDirectoryURL: URL {
        get {
            guard let documentPath = self.fileManager.urls(for: .documentDirectory,
                                                           in: .userDomainMask).first
            else { return URL(fileURLWithPath: "") }
            
            return documentPath
        }
    }
}

extension FileManag: IFileManag {
    
    func AllFilesFromDirectory() -> [String] {
        do {
            let url = self.documentDirectoryURL
            return try self.fileManager.contentsOfDirectory(atPath: url.path)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fileExist(atPath: String) -> Bool {
        self.fileManager.fileExists(atPath: atPath)
    }
    
    func moveItem(at: URL, to: URL) {
        do {
            try self.fileManager.moveItem(at: at, to: to)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func appendingPathComponent(_ string: String) -> URL {
        self.documentDirectoryURL.appendingPathComponent(string)
    }
}
