//
//  Converter.swift
//  Player
//
//  Created by pavel mishanin on 16.09.2022.
//

import Foundation

enum Converter {
    
    static func stringFrom(interval: TimeInterval) -> String {
        let ti = NSInteger(interval)
        
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d:%0.2d",hours, minutes, seconds, ms)
    }
}
