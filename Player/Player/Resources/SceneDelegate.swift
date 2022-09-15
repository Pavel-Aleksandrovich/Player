//
//  SceneDelegate.swift
//  Player
//
//  Created by pavel mishanin on 14.09.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: PlayerViewController())
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}

