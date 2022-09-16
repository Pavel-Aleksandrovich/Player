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
    var numberOfLoops: Int { get set }
    var currentTime: TimeInterval { get set }
    var duration: TimeInterval { get }
    var isPlaying: Bool { get }
    func pause()
    func play()
    func setSong(string: String)
}

final class AudioPlayer {
    
    private var player = AVAudioPlayer()
    
    var numberOfLoops: Int {
        get {
            self.player.numberOfLoops
        }
        set {
            self.player.numberOfLoops = newValue
        }
    }
    
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
    
    var loopState: LoopState = .off
    
    
    init() {
    }
}

extension AudioPlayer: IAudioPlayer {
    
    func pause() {
        self.player.pause()
    }
    
    func play() {
        self.player.play()
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
            self.player.play()
            self.player.numberOfLoops = self.loopState.rawValue
        } catch {
            print(error.localizedDescription)
        }
    }
}

