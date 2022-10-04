//
//  DataStorage.swift
//  Player
//
//  Created by pavel mishanin on 16.09.2022.
//

import Foundation

protocol IDataManager: AnyObject {
    var getAll: [Track] { get }
    var getCurrentIndex: Int { get }
    var getCurrentSong: Track { get }
    func nextTapped()
    func previousTapped()
    func setIndex(_ index: Int)
    func setSong()
    func setData(_ array: [Track])
}

final class DataManager {
    
    private let dataStorage = DataStorage.shared
    
    var getAll: [Track] {
        self.dataStorage.songsArray
    }
    
    var getCurrentIndex: Int {
        self.dataStorage.index
    }
    
    var getCurrentSong: Track {
        self.dataStorage.songsArray[self.dataStorage.index]
    }
}

extension DataManager: IDataManager {
    
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
