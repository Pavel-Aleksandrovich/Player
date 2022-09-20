//
//  FileManag.swift
//  Player
//
//  Created by pavel mishanin on 19.09.2022.
//

import UIKit

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = true ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}

final class FileManag {
    
    func findFilesWith(extensionType: String) -> [URL] {
        var matches = [URL]()
        
        let fileManager = FileManager.default
//
//
//        let files = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
//        print(files)
//
//        let result = try? fileManager.contents(atPath: files)
//
//        print(result)
//
//        let fold = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        print(fold)
        
        
        
        do {
            // Get the document directory url
            let documentDirectory = try fileManager.url(
                for: .musicDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            
            print("documentDirectory", documentDirectory.path)
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try fileManager.contentsOfDirectory(
                at: documentDirectory,
                includingPropertiesForKeys: nil
            )
            
            
            print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
            
            for url in directoryContents {
                print(url.localizedName ?? url.lastPathComponent)
            }
            
            // if you would like to hide the file extension
            for var url in directoryContents {
                url.hasHiddenExtension = true
            }
            for url in directoryContents {
                print(url.localizedName ?? url.lastPathComponent)
            }

            // if you want to get all mp3 files located at the documents directory:
            let mp3 = directoryContents.filter(\.isMP3).map { $0.localizedName ?? $0.lastPathComponent }
            print("mp3:", mp3)
            
        } catch {
            print(error)
        }
        
        
        let fileMngr = FileManager.default;
        
        // Full path to documents directory
        let docs = fileMngr.urls(for: .musicDirectory, in: .userDomainMask)[0].path
        
        // List all contents of directory and return as [String] OR nil if failed
        print( try? fileMngr.contentsOfDirectory(atPath:docs) )
        
        
        return matches
    }
}

extension URL {
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    
    var isMP3: Bool { typeIdentifier == "mp3" }
    
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
    
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
