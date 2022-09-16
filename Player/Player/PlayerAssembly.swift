//
//  PlayerAssembly.swift
//  Player
//
//  Created by pavel mishanin on 15.09.2022.
//

import UIKit

enum PlayerAssembly {
    
    static func build() -> UIViewController {
        
        let router = PlayerRouter()
        let player = AudioPlayer()
        let dataStorage = DataStorage()
        let presenter = PlayerPresenter(router: router,
                                        player: player,
                                        dataStorage: dataStorage)
        let controller = PlayerViewController(presenter: presenter)
        router.controller = controller
        
        return controller
    }
}

