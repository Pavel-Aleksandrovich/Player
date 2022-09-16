//
//  PlayerRouter.swift
//  Player
//
//  Created by pavel mishanin on 15.09.2022.
//

import Foundation
import UIKit

protocol IPlayerRouter: AnyObject {
    func pushToPlaylist(completion: @escaping(Int) -> ())
}

final class PlayerRouter {
    
    weak var controller: UIViewController?
}

extension PlayerRouter: IPlayerRouter {
    
    func pushToPlaylist(completion: @escaping(Int) -> ()) {
        let vc = PlaylistAssembly.build(completion: completion)
        let navigationController = UINavigationController(rootViewController: vc)
        self.controller?.present(navigationController, animated: true)
    }
}
