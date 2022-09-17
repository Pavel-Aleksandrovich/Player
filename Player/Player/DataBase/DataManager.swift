//
//  DataStorage.swift
//  Player
//
//  Created by pavel mishanin on 16.09.2022.
//

import Foundation

protocol IDataManager: AnyObject {
    func getAll() -> [String]
    func getSongByIndex(_ index: Int) -> String
    func getCurrentSong() -> String
    func nextTapped()
    func previousTapped()
    func setIndex(_ index: Int)
    func getCurrentIndex() -> Int
    func setSong()
}

final class DataManager {
    
    private let dataStorage = DataStorage.shared
}

extension DataManager: IDataManager {
    
    func getAll() -> [String] {
        self.dataStorage.songsArray
    }
    
    func getSongByIndex(_ index: Int) -> String {
        self.dataStorage.songsArray[index]
    }
    
    func getFirstSong() -> String {
        self.dataStorage.songsArray.first ?? ""
    }
    
    func getCurrentSong() -> String {
        self.dataStorage.songsArray[self.dataStorage.index]
    }
    
    func getCurrentIndex() -> Int {
        self.dataStorage.index
    }
    
    func nextTapped() {
        if (self.dataStorage.index + 1) == self.dataStorage.songsArray.count {
            self.dataStorage.index = 0
        } else {
            self.dataStorage.index += 1
        }
    }
    
    func previousTapped() {
        if self.dataStorage.songsArray.isEmpty == false {
            self.dataStorage.index -= 1
        }
        
        if self.dataStorage.index < 0 {
            self.dataStorage.index = self.dataStorage.songsArray.count - 1
        }
    }
    
    func setIndex(_ index: Int) {
        self.dataStorage.index = index
    }
    
    func setSong() {
        self.dataStorage.song = self.dataStorage.songsArray[self.dataStorage.index]
    }
}
