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
        let dataManager = DataManager()
        let networkManager = NetworkManager()
        let presenter = PlayerPresenter(router: router,
                                        player: player,
                                        dataManager: dataManager,
                                        networkManager: networkManager)
        let controller = PlayerViewController(presenter: presenter)
        router.controller = controller
        
        return controller
    }
}

