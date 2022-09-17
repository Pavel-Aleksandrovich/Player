//
//  Image.swift
//  Player
//
//  Created by pavel mishanin on 17.09.2022.
//

import UIKit

enum PlayerImage {
    case pause
    case play
    case loopOff
    case loopOn
    case music
    case next
    case previous
    case playlist
    
    var name: UIImage? {
        switch self {
        case .pause: return UIImage(systemName: "pause.fill")
        case .play: return UIImage(systemName: "play.fill")
        case .loopOff: return UIImage(systemName: "repeat")
        case .loopOn: return UIImage(systemName: "repeat.circle.fill")
        case .music: return UIImage(systemName: "music.note")
        case .next: return UIImage(systemName: "forward.end.fill")
        case .previous: return UIImage(systemName: "backward.end.fill")
        case .playlist: return UIImage(systemName: "list.triangle")
        }
    }
}
