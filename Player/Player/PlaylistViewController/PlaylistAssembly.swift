//
//  PlaylistAssembly.swift
//  Player
//
//  Created by pavel mishanin on 15.09.2022.
//

import UIKit

enum PlaylistAssembly {
    
    static func build(isPlay: Bool,
                      completion: @escaping(Int) -> ()) -> UIViewController {
        
        let presenter = PlaylistPresenter(isPlay: isPlay,
                                          completion: completion)
        let controller = PlaylistViewController(presenter: presenter)
        
        return controller
    }
}
