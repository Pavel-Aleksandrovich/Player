//
//  DataStorage.swift
//  Player
//
//  Created by pavel mishanin on 16.09.2022.
//

import Foundation

protocol IDataStorage: AnyObject {
    var index: Int { get set }
    func getAll() -> [String]
    func getSongByIndex(_ index: Int) -> String
    func getCurrentSong() -> String
    func nextTapped()
    func previousTapped()
}

final class DataStorage {
    
    var index = Int() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("cUrReNtSoNgSeTnOtIfIcAtIoN"), object: nil)
        }
    }
    
    private let songsArray: [String] = ["11", "22", "33"]
}

extension DataStorage: IDataStorage {
    
    func getAll() -> [String] {
        self.songsArray
    }
    
    func getSongByIndex(_ index: Int) -> String {
        self.songsArray[index]
    }
    
    func getFirstSong() -> String {
        self.songsArray.first ?? ""
    }
    
    func getCurrentSong() -> String {
        self.songsArray[self.index]
    }
    
    func nextTapped() {
        if (self.index + 1) == self.songsArray.count {
            self.index = 0
        } else {
            self.index += 1
        }
    }
    
    func previousTapped() {
        if self.songsArray.isEmpty == false {
            self.index -= 1
        }
        
        if self.index < 0 {
            self.index = self.songsArray.count - 1
        }
    }
}
