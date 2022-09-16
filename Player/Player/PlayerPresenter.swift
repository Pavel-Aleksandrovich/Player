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
    private let dataStorage: IDataStorage
//    private var songsArray: [String] = ["11", "22", "33"]
//    private var index = Int()
    
    init(router: IPlayerRouter,
         player: IAudioPlayer,
         dataStorage: IDataStorage) {
        self.router = router
        self.player = player
        self.dataStorage = dataStorage
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(onSongChange), name: NSNotification.Name("cUrReNtSoNgSeTnOtIfIcAtIoN"), object: nil)
    }
    
    @objc func onSongChange() {
        print(#function)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = NSInteger(interval)
        
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d:%0.2d",hours, minutes, seconds, ms)
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
            
            self.dataStorage.nextTapped()
            self.configPlayer()
        }
    }
    
    func setOnPreviousTappedHandler() {
        self.controller?.onPreviousTappedHandler = { [ weak self ] in
            guard let self = self else { return }
            self.dataStorage.previousTapped()
            self.configPlayer()
        }
    }
    
    func setOnDisplayLinkChangeHandler() {
        self.controller?.onDisplayLinkChangeHandler = { [ weak self ] in
            guard let self = self else { return }
            
            let currentTime = self.player.currentTime
            let duration = self.player.duration
            
            self.controller?.maximumDurationLabelText = self.stringFromTimeInterval(interval: duration)
            
            self.controller?.minimumDurationLabelText = self.stringFromTimeInterval(interval: currentTime)
            
            self.controller?.sliderValue = Float(currentTime)
        }
    }
    
    func setOnPlaylistScreenTappedHandler() {
        self.controller?.onPlaylistScreenTappedHandler = { [ weak self ] in
            self?.router.pushPlaylistViewController()
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
    
    func configPlayer() {
        if self.dataStorage.getAll().isEmpty == false {
            
            self.player.setSong(string: self.dataStorage.getCurrentSong())
//            self.player.play()
//            self.player.numberOfLoops = self.player.loopState.rawValue
            self.controller?.sliderMaximumValue = Float(self.player.duration)
        }
    }
}
