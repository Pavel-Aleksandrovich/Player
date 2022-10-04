//
//  PlaylistPresenter.swift
//  Player
//
//  Created by pavel mishanin on 16.09.2022.
//

import UIKit

protocol IPlaylistPresenter: AnyObject {
    var getNumberOfRowsInSection: Int { get }
    func onViewAttached(controller: IPlaylistViewController)
    func getSongById(_ index: Int) -> Track
    func getSelectedSong(_ index: Int) -> UIImage?
    func removeObserver()
}

final class PlaylistPresenter {
    
    private weak var controller: IPlaylistViewController?
    private let dataStorage = DataStorage.shared
    private let completion: (Int) -> ()
    private var isPlay: Bool
    
    var getNumberOfRowsInSection: Int {
        self.dataStorage.songsArray.count
    }
    
    init(isPlay: Bool,
         completion: @escaping(Int) -> ()) {
        self.completion = completion
        self.isPlay = isPlay
    }
}

extension PlaylistPresenter: IPlaylistPresenter {
    
    func onViewAttached(controller: IPlaylistViewController) {
        self.controller = controller
        
        self.setOnCellTappedHandler()
        self.addObserver()
    }
    
    func getSongById(_ index: Int) -> Track {
        self.dataStorage.songsArray[index]
    }
    
    func getSelectedSong(_ index: Int) -> UIImage? {
        if self.dataStorage.song != nil {
            if index == self.dataStorage.index {
                switch self.isPlay {
                case true:
                    return PlayerImage.pause.name
                case false:
                    return PlayerImage.play.name
                }
            }
        }
        
        return PlayerImage.music.name
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: PlayerNotification.didFinish.name,
            object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: PlayerNotification.didPause.name,
            object: nil)
        
        NotificationCenter.default.removeObserver(
            self,
            name: PlayerNotification.didPlay.name,
            object: nil)
    }
}

private extension PlaylistPresenter {
    
    func setOnCellTappedHandler() {
        self.controller?.onCellTappedHandler = { [ weak self ] index in
            self?.completion(index)
            self?.controller?.reloadData()
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.playerDidFinishPlaying),
            name: PlayerNotification.didFinish.name,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.audioPlayerDidPause),
            name: PlayerNotification.didPause.name,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.audioPlayerDidPlay),
            name: PlayerNotification.didPlay.name,
            object: nil)
    }
    
    @objc func playerDidFinishPlaying() {
        self.controller?.reloadData()
    }
    
    @objc func audioPlayerDidPlay() {
        self.isPlay = true
        self.controller?.reloadData()
    }
    
    @objc func audioPlayerDidPause() {
        self.isPlay = false
        self.controller?.reloadData()
    }
}
