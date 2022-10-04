//
//  FileManag.swift
//  Player
//
//  Created by pavel mishanin on 19.09.2022.
//

import UIKit
import MediaPlayer

final class FileManag {
    
    func findFilesWith() {
        let fileManager = FileManager.default
        /// Full path to documents directory
        let urls = fileManager.urls(for: .downloadsDirectory,
                                   in: .userDomainMask)
        
        print(urls)
        
        /// List all contents of directory and return as [String] OR nil if failed
        let content = try? fileManager.contentsOfDirectory(at: urls[0],
                                                 includingPropertiesForKeys: nil)
        
        print(content)
        
        let query = MPMediaQuery.songs().items
        let mediaCollection = MPMediaItemCollection(items: query ?? [])
        
        print(mediaCollection)
    }
}
