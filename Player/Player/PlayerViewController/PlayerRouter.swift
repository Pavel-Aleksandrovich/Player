//
//  PlayerRouter.swift
//  Player
//
//  Created by pavel mishanin on 15.09.2022.
//

import UIKit

protocol IPlayerRouter: AnyObject {
    func pushToPlaylist(isPlay: Bool,
                        completion: @escaping(Int) -> ())
}

final class PlayerRouter {
    
    weak var controller: UIViewController?
}

extension PlayerRouter: IPlayerRouter {
    
    func pushToPlaylist(isPlay: Bool,
                        completion: @escaping(Int) -> ()) {
        let vc = PlaylistAssembly.build(isPlay: isPlay,
                                        completion: completion)
        let navigationController = UINavigationController(rootViewController: vc)
        self.controller?.present(navigationController, animated: true)
    }
}
