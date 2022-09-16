//
//  PlayerRouter.swift
//  Player
//
//  Created by pavel mishanin on 15.09.2022.
//

import Foundation
import UIKit

protocol IPlayerRouter: AnyObject {
    func pushPlaylistViewController()
}

final class PlayerRouter {
    
    weak var controller: UIViewController?
}

extension PlayerRouter: IPlayerRouter {
    
    func pushPlaylistViewController() {
        let vc = PlaylistAssembly.build()
        let navigationController = UINavigationController(rootViewController: vc)
//        self.controller?.present(navigationController, animated: true)
//        navigationController.modalPresentationStyle = .overCurrentContext
//        navigationController.modalTransitionStyle = .coverVertical
//        navigationController.navigationController?.navigationBar.isTranslucent = true
        print(#function)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.transitionCrossDissolve], animations: { [weak self] in
            self?.controller?.present(navigationController, animated: true)
        }, completion: nil)
    }
}
