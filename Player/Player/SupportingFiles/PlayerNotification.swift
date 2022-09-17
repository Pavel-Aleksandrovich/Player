//
//  Notification.swift
//  Player
//
//  Created by pavel mishanin on 17.09.2022.
//

import Foundation

enum PlayerNotification {
    case didFinish
    case didPause
    case didPlay
    
    var name: NSNotification.Name {
        switch self {
        case .didFinish:
            return NSNotification.Name("audioPlayerDidFinish")
        case .didPause:
            return NSNotification.Name("audioPlayerDidPause")
        case .didPlay:
            return NSNotification.Name("audioPlayerDidPlay")
        }
    }
}
