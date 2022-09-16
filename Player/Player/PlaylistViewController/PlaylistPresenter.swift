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
    func getSelectedSong(_ index: Int) -> String
}

final class PlaylistPresenter {
    
    private weak var controller: IPlaylistViewController?
    private let dataStorage = DataStorage.shared
    private let completion: (Int) -> ()
    
    init(completion: @escaping(Int) -> ()) {
        self.completion = completion
    }
}

extension PlaylistPresenter: IPlaylistPresenter {
    
    func onViewAttached(controller: IPlaylistViewController) {
        self.controller = controller
        
        self.controller?.onCellTappedHandler = { [ weak self ] index in
            self?.completion(index)
            self?.controller?.reloadData()
        }
    }
    
    func numberOfRowsInSection() -> Int {
        self.dataStorage.songsArray.count
    }
    
    func getSongById(_ index: Int) -> String {
        self.dataStorage.songsArray[index]
    }
    
    func getSelectedSong(_ index: Int) -> String {
        if index == self.dataStorage.index {
            return "play.fill"
        } else {
            return "music.note"
        }
    }
}
