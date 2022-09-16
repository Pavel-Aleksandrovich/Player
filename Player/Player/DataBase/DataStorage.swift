//
//  DataStorage.swift
//  Player
//
//  Created by pavel mishanin on 16.09.2022.
//

import Foundation

final class DataStorage {
    
    static let shared = DataStorage()
    
    private init() {}
    
    var index = Int()
    
    let songsArray: [String] = ["11", "22", "33"]
}