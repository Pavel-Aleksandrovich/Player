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
    
    var index = Int() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("cUrReNtSoNgSeTnOtIfIcAtIoN"), object: nil)
        }
    }
    
    let songsArray: [String] = ["11", "22", "33"]
}
