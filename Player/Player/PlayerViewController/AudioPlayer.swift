//
//  AudioPlayer.swift
//  Player
//
//  Created by pavel mishanin on 16.09.2022.
//

import UIKit
import AVFoundation

protocol IAudioPlayer: AnyObject {
    var loopState: LoopState { get set }
    var currentTime: TimeInterval { get set }
    var duration: TimeInterval { get }
    var isPlaying: Bool { get }
    func pause()
    func play()
    func setSong(string: String)
}

final class AudioPlayer: NSObject {
    
    private var player = AVAudioPlayer()
    
    var isPlaying: Bool {
        get {
            self.player.isPlaying
        }
    }
    
    var currentTime: TimeInterval {
        get {
            self.player.currentTime
        }
        set {
            self.player.currentTime = newValue
        }
    }
    
    var duration: TimeInterval {
        get {
            self.player.duration
        }
    }
    
    var loopState: LoopState = .off {
        didSet {
            self.player.numberOfLoops = self.loopState.rawValue
        }
    }
}

extension AudioPlayer: IAudioPlayer {
    
    func pause() {
        self.player.pause()
        
        NotificationCenter.default.post(
            name: PlayerNotification.didPause.name,
            object: nil)
    }
    
    func play() {
        self.player.play()
        
        NotificationCenter.default.post(
            name: PlayerNotification.didPlay.name,
            object: nil)
    }
    
    func setSong(string: String) {
        guard let string = Bundle.main.path(forResource: string,
                                            ofType: "mp3") else {
            print("string error")
            return }
        
        guard let url = URL(string: string) else {
            print("url error")
            return }
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.play()
            self.player.numberOfLoops = self.loopState.rawValue
        } catch {
            print(error.localizedDescription)
        }
        self.player.delegate = self
    }
    
}

extension AudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                     successfully flag: Bool) {
        
        if player.currentTime == 0 {
            NotificationCenter.default.post(
                name: PlayerNotification.didFinish.name,
                object: nil)
        }
    }
}

