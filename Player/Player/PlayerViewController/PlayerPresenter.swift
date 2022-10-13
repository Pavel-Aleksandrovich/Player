//
//  PlayerPresenter.swift
//  Player
//
//  Created by pavel mishanin on 15.09.2022.
//

import Foundation

protocol IPlayerPresenter: AnyObject {
    func onViewAttached(controller: IPlayerViewController)
    func removeObserver()
}

final class PlayerPresenter {
    
    private weak var controller: IPlayerViewController?
    private let router: IPlayerRouter
    private let player: IAudioPlayer
    private let dataManager: IDataManager
    private let fileManager: IFileManag
    private let networkManager: INetworkManager
    private let group = DispatchGroup()
    
    init(router: IPlayerRouter,
         player: IAudioPlayer,
         dataManager: IDataManager,
         fileManager: IFileManag,
         networkManager: INetworkManager) {
        self.router = router
        self.player = player
        self.dataManager = dataManager
        self.fileManager = fileManager
        self.networkManager = networkManager
    }
}

extension PlayerPresenter: IPlayerPresenter {
    
    func onViewAttached(controller: IPlayerViewController) {
        self.controller = controller
        
        self.setOnLoopTappedHandler()
        self.setOnNextTappedHandler()
        self.setOnPreviousTappedHandler()
        self.setOnDisplayLinkChangeHandler()
        self.setOnPlaylistScreenTappedHandler()
        self.setOnSliderValueChangeHandler()
        self.setOnPlayTappedHandler()
        self.addObserver()
        self.loadFromDirectory()
        self.setOnFileSelectedFromFileAppHandler()
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: PlayerNotification.didFinish.name,
            object: nil)
    }
}

private extension PlayerPresenter {
    
    func setOnFileSelectedFromFileAppHandler() {
        self.controller?.onDocumentPickerSelectedHandler = { [ weak self ] urls in
            guard let self = self else { return }
            self.moveToDirectory(urls: urls)
            self.loadFromDirectory()
        }
    }
    
    func setOnLoopTappedHandler() {
        self.controller?.onLoopTappedHandler = { [ weak self ] in
            guard let self = self else { return }
            switch self.player.loopState {
            case .off:
                self.player.loopState = .on
                self.controller?.setLoopImage(PlayerImage.loopOn.name)
            case .on:
                self.player.loopState = .off
                self.controller?.setLoopImage(PlayerImage.loopOff.name)
            }
        }
    }
    
    func setOnNextTappedHandler() {
        self.controller?.onNextTappedHandler = { [ weak self ] in
            guard let self = self else { return }
            
            if self.player.loopState == .off {
                self.dataManager.nextTapped()
            }
            self.configPlayer()
        }
    }
    
    func setOnPreviousTappedHandler() {
        self.controller?.onPreviousTappedHandler = { [ weak self ] in
            guard let self = self else { return }
            
            if self.player.loopState == .off {
                self.dataManager.previousTapped()
            }
            self.configPlayer()
        }
    }
    
    func setOnDisplayLinkChangeHandler() {
        self.controller?.onDisplayLinkChangeHandler = { [ weak self ] in
            guard let self = self else { return }
            
            let currentTime = self.player.currentTime
            let duration = self.player.duration
            
            self.controller?.maximumDurationLabelText = Converter.stringFrom(interval: duration)
            
            self.controller?.minimumDurationLabelText = Converter.stringFrom(interval: currentTime)
            
            self.controller?.sliderValue = Float(currentTime)
        }
    }
    
    func setOnPlaylistScreenTappedHandler() {
        self.controller?.onPlaylistScreenTappedHandler = { [ weak self ] in
            guard let self = self else { return }
            
            let isPlay = self.player.isPlaying
            
            self.router.pushToPlaylist(isPlay: isPlay,
                                        completion: {
                [ weak self ] index in
                guard let self = self else { return }
                
                if index == self.dataManager.getCurrentIndex {
                    self.playTap()
                } else {
                    self.dataManager.setIndex(index)
                    self.configPlayer()
                    self.setPlayImage()
                }
            })
        }
    }
    
    func setOnSliderValueChangeHandler() {
        self.controller?.onSliderValueChangeHandler = { [ weak self ] in
            guard let self = self,
                  let controller = self.controller else { return }
            
            self.player.play()
            self.player.currentTime = Double(controller.sliderValue)
        }
    }
    
    func setOnPlayTappedHandler() {
        self.controller?.onPlayTappedHandler = { [ weak self ] in
            guard let self = self else { return }
            self.playTap()
        }
    }
    
    func setPlayImage() {
        switch self.player.isPlaying {
        case true:
            self.controller?.setPlayImage(PlayerImage.pause.name)
        case false:
            self.controller?.setPlayImage(PlayerImage.play.name)
        }
    }
    
    func moveToDirectory(urls: [URL]) {
        for url in urls {
            
            let documentUrl = self.fileManager.appendingPathComponent(url.lastPathComponent)
            
            if self.fileManager.fileExist(atPath: documentUrl.path) == false {
                self.group.enter()
                self.networkManager.downloadTask(url: url) { url in
                    self.fileManager.moveItem(at: url, to: documentUrl)
                    self.group.leave()
                }
                self.group.wait()
            }
            self.group.wait()
        }
    }
    
    func configPlayer() {
        if self.dataManager.getAll.isEmpty == false {
            
            self.dataManager.setSong()
            self.player.setSong(string: self.dataManager.getCurrentSong.url)
            self.controller?.sliderMaximumValue = Float(self.player.duration)
            self.setPlayImage()
        }
    }
    
    func playTap() {
        switch self.player.isPlaying {
        case true:
            self.player.pause()
            self.controller?.setPlayImage(PlayerImage.play.name)
        case false:
            self.player.play()
            self.controller?.setPlayImage(PlayerImage.pause.name)
            
            if self.player.currentTime == 0 {
                self.configPlayer()
            }
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.playerDidFinishPlaying),
            name: PlayerNotification.didFinish.name,
            object: nil)
    }
    
    @objc func playerDidFinishPlaying() {
        self.dataManager.nextTapped()
        self.configPlayer()
    }
    
    func loadFromDirectory() {
        let allFiles = self.fileManager.AllFilesFromDirectory()
        
        let musicFiles = self.filter(string: allFiles)
        
        for file in musicFiles {
            
            let url = self.fileManager.appendingPathComponent(file)
            
            if self.dataManager.getAll.contains(where: { $0.url == "\(url)" }) == false {
                
                guard let track = self.player.getTrack(url: url) else { return }
                
                self.dataManager.append([track])
            }
        }
    }
    
    func filter(string: [String]) -> [String] {
        let extensions = ["mp3", "ac3", "wav", ".au", "aac", "iff", "m4a"]
        
        return string.filter { extensions.contains(String($0.suffix(3))) }
    }
}
