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
    func getTrack(url: URL) -> TrackRequest?
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
        guard let url = URL(string: string) else {
            print("\(#function) <--- URL ERROR")
            return }
        
        do {
            let data = try Data(contentsOf: url)
            self.player = try AVAudioPlayer(data: data)
            self.player.prepareToPlay()
            self.play()
            self.player.numberOfLoops = self.loopState.rawValue
        } catch {
            print("\(#function) - ERROR: \(error.localizedDescription)")
        }
        self.player.delegate = self
    }
    
    func getTrack(url: URL) -> TrackRequest? {
        var title = String()
        var artist = String()
        var album = String()
        var genre = String()
        var artwork = Data()
        
        let assetMetadata = AVPlayerItem(url: url).asset.commonMetadata
        
        for item in assetMetadata {
            guard let commonKey = item.commonKey else { return nil }
            
            switch commonKey.rawValue {
            case "title":
                title = item.stringValue ?? ""
            case "artist":
                artist = item.stringValue ?? ""
            case "albumName":
                album = item.stringValue ?? ""
            case "type":
                genre = item.stringValue ?? ""
            case "artwork":
                artwork = item.dataValue ?? Data()
            default:
                break
            }
        }
        
        let track = TrackRequest(title: title,
                                 artist: artist,
                                 album: album,
                                 genre: genre,
                                 artwork: artwork,
                                 url: "\(url)")
        
        return track
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

