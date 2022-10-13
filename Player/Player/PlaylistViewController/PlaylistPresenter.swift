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
    func getSongById(_ index: Int) -> TrackRequest
    func getSelectedSong(_ index: Int) -> UIImage?
    func removeObserver()
}

final class PlaylistPresenter {
    
    private weak var controller: IPlaylistViewController?
    private let dataStorage = DataStorage.shared
    private let networkManager: INetworkManager
    private let completion: (Int) -> ()
    private var isPlay: Bool
    
    var getNumberOfRowsInSection: Int {
        self.dataStorage.songsArray.count
    }
    
    init(isPlay: Bool,
         completion: @escaping(Int) -> (),
         networkManager: INetworkManager) {
        self.completion = completion
        self.isPlay = isPlay
        self.networkManager = networkManager
    }
}

extension PlaylistPresenter: IPlaylistPresenter {
    
    func onViewAttached(controller: IPlaylistViewController) {
        self.controller = controller
        
        self.setOnCellTappedHandler()
        self.addObserver()
        
        self.controller?.onSearchHandler = { [ weak self ] text in
            print(text)
            self?.networkManager.fetchSearchData(query: text) { result in
                switch result {
                case .success(let array):
                    DispatchQueue.main.async {
                        let array = array.map { TrackRequest(viewModel: $0)}
                        self?.dataStorage.songsArray.append(contentsOf: array)
                        self?.controller?.reloadData()
                    }
                case .failure(let error):
                    print("\(#function) ERROR: ---> \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getSongById(_ index: Int) -> TrackRequest {
        self.dataStorage.songsArray[index]
    }
    
    func getSelectedSong(_ index: Int) -> UIImage? {
        if index == self.dataStorage.index && self.dataStorage.song != nil {
            switch self.isPlay {
            case true:
                return PlayerImage.pause.name
            case false:
                return PlayerImage.play.name
            }
        } else {
            if let image = UIImage(data: self.dataStorage.songsArray[index].artwork) {
                return image
            } else {
                return PlayerImage.music.name
            }
        }
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
