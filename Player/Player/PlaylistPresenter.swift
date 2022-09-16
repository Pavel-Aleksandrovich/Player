//
//  PlaylistPresenter.swift
//  Player
//
//  Created by pavel mishanin on 16.09.2022.
//

import Foundation

protocol IPlaylistPresenter: AnyObject {
    func onViewAttached(controller: IPlaylistViewController)
    func numberOfRowsInSection() -> Int
    func getSongById(_ index: Int) -> String
}

final class PlaylistPresenter {
    
    private weak var controller: IPlaylistViewController?
}

extension PlaylistPresenter: IPlaylistPresenter {
    
    func onViewAttached(controller: IPlaylistViewController) {
        self.controller = controller
    }
    
    func numberOfRowsInSection() -> Int {
        0
    }
    
    func getSongById(_ index: Int) -> String {
        ""
    }
}
