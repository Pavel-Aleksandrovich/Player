//
//  PlayerPresenter.swift
//  Player
//
//  Created by pavel mishanin on 15.09.2022.
//

import Foundation

protocol IPlayerPresenter: AnyObject {
    func onViewAttached(controller: IPlayerViewController)
}

final class PlayerPresenter {
    
    private weak var controller: IPlayerViewController?
    private let router: IPlayerRouter
    private let player: IAudioPlayer
    private let dataManager: IDataManager
    
    init(router: IPlayerRouter,
         player: IAudioPlayer,
         dataManager: IDataManager) {
        self.router = router
        self.player = player
        self.dataManager = dataManager
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name("audioPlayerDidFinishPlaying"), object: nil)
    }
    
    @objc func playerDidFinishPlaying() {
        self.dataManager.nextTapped()
        self.configPlayer()
    }
}

private extension PlayerPresenter {
    
    func setOnLoopTappedHandler() {
        self.controller?.onLoopTappedHandler = { [ weak self ] in
            guard let self = self else { return }
            switch self.player.loopState {
            case .off:
                self.player.loopState = .on
                self.controller?.setLoopImage(string: "repeat.circle.fill")
                self.player.numberOfLoops = self.player.loopState.rawValue
            case .on:
                self.player.loopState = .off
                self.controller?.setLoopImage(string: "repeat")
                self.player.numberOfLoops = self.player.loopState.rawValue
            }
        }
    }
    
    func setOnNextTappedHandler() {
        self.controller?.onNextTappedHandler = { [ weak self ] in
            guard let self = self else { return }
            
            self.dataManager.nextTapped()
            self.configPlayer()
        }
    }
    
    func setOnPreviousTappedHandler() {
        self.controller?.onPreviousTappedHandler = { [ weak self ] in
            guard let self = self else { return }
            self.dataManager.previousTapped()
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
            self?.router.pushToPlaylist(completion: {
                [ weak self ] index in
                guard let self = self else { return }
                
                if index == self.dataManager.getCurrentIndex() {
                    self.playTap()
                } else {
                    self.dataManager.setIndex(index)
                    self.configPlayer()
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
    
    func configPlayer() {
        if self.dataManager.getAll().isEmpty == false {
            
            self.player.setSong(string: self.dataManager.getCurrentSong())
            self.controller?.sliderMaximumValue = Float(self.player.duration)
        }
    }
    
    func playTap() {
        switch self.player.isPlaying {
        case true:
            self.player.pause()
            self.controller?.setPlayImage(string: "play.fill")
        case false:
            self.player.play()
            self.controller?.setPlayImage(string: "pause.fill")
            
            if self.player.currentTime == 0 {
                self.configPlayer()
            }
        }
    }
}
