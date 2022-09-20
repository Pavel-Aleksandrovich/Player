//
//  DataStorage.swift
//  Player
//
//  Created by pavel mishanin on 16.09.2022.
//

import Foundation

protocol IDataManager: AnyObject {
    func getAll() -> [Track]
    func getSongByIndex(_ index: Int) -> Track
    func getCurrentSong() -> Track
    func nextTapped()
    func previousTapped()
    func setIndex(_ index: Int)
    func getCurrentIndex() -> Int
    func setSong()
    func setData(_ array: [Track])
}

final class DataManager {
    
    private let dataStorage = DataStorage.shared
}

extension DataManager: IDataManager {
    
    func getAll() -> [Track] {
        self.dataStorage.songsArray
    }
    
    func getSongByIndex(_ index: Int) -> Track {
        self.dataStorage.songsArray[index]
    }
    
    func getCurrentSong() -> Track {
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
    
    func setData(_ array: [Track]) {
        self.dataStorage.songsArray.append(contentsOf: array)
    }
}
