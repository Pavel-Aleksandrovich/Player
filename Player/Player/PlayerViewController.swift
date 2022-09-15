//
//  PlayerViewController.swift
//  Player
//
//  Created by pavel mishanin on 14.09.2022.
//

import UIKit
import AVFoundation

final class PlayerViewController: UIViewController {

    private let playImageView = UIImageView()
    private let nextImageView = UIImageView()
    private let previousImageView = UIImageView()
    private let posterImageView = UIImageView()
    private let slider = UISlider()
    private let loopButton = UIButton()
    private let minimumDurationLabel = UILabel()
    private let maximumDurationLabel = UILabel()
    private var caDisplayLinkTimer = CADisplayLink()
    private var isPlay = true
    private var songsArray = ["song1", "song2", "song3", "11", "22", "33"]
    private var player = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let string = Bundle.main.path(forResource: songsArray[3],
                                      ofType: "mp3")
        
        try! AVAudioSession.sharedInstance().setMode(.default)
        try! AVAudioSession.sharedInstance().setActive(true,
                                                       options: .notifyOthersOnDeactivation)
        
        
        let url = URL(string: string!)
        
        guard let url = url else { print("url error")
            return }
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player.play()
        } catch {
            print(error.localizedDescription)
        }
        
        
        
        
        let image = UIImage(systemName: "list.triangle")
        let item = UIBarButtonItem(image: image,
                                   style: .plain,
                                   target: self,
                                   action: #selector
                                   (self.onBarButtonTapped))
        item.tintColor = .black
        self.navigationItem.rightBarButtonItem = item
        
        self.posterImageView.backgroundColor = .gray
//        self.posterImageView.image = UIImage(systemName: "play")
        self.posterImageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(self.posterImageView)
        self.posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.posterImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            self.posterImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            self.posterImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
        
        
        self.playImageView.backgroundColor = .clear
        self.playImageView.image = UIImage(systemName: "play")
        self.playImageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(self.playImageView)
        self.playImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.playImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.playImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.playImageView.heightAnchor.constraint(equalToConstant: 80),
            self.playImageView.widthAnchor.constraint(equalToConstant: 80),
        ])
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(onPlayTapped))
        self.playImageView.addGestureRecognizer(gesture)
        self.playImageView.isUserInteractionEnabled = true
        
        self.nextImageView.backgroundColor = .clear
        self.nextImageView.image = UIImage(systemName: "play")
        self.nextImageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(self.nextImageView)
        self.nextImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.nextImageView.centerYAnchor.constraint(equalTo: self.playImageView.centerYAnchor),
            self.nextImageView.leadingAnchor.constraint(equalTo: self.playImageView.trailingAnchor, constant: 50),
            self.nextImageView.heightAnchor.constraint(equalToConstant: 40),
            self.nextImageView.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        self.previousImageView.backgroundColor = .clear
        self.previousImageView.image = UIImage(systemName: "play")
        self.previousImageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(self.previousImageView)
        self.previousImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.previousImageView.centerYAnchor.constraint(equalTo: self.playImageView.centerYAnchor),
            self.previousImageView.trailingAnchor.constraint(equalTo: self.playImageView.leadingAnchor, constant: -50),
            self.previousImageView.heightAnchor.constraint(equalToConstant: 40),
            self.previousImageView.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        self.slider.minimumTrackTintColor = .label.withAlphaComponent(0.8)
        self.slider.maximumTrackTintColor = .systemGray.withAlphaComponent(0.5)
        self.slider.thumbTintColor = .label.withAlphaComponent(0.8)
//        self.slider.isContinuous = false
        
        self.view.addSubview(self.slider)
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.slider.bottomAnchor.constraint(equalTo: self.playImageView.topAnchor, constant: -50),
            self.slider.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            self.slider.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
        
        self.minimumDurationLabel.textColor = .secondaryLabel
        self.minimumDurationLabel.textAlignment = .left
        self.minimumDurationLabel.text = "00:00:00:00"
        
        self.view.addSubview(self.minimumDurationLabel)
        self.minimumDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.minimumDurationLabel.topAnchor.constraint(equalTo: self.slider.bottomAnchor, constant: 5),
            self.minimumDurationLabel.leadingAnchor.constraint(equalTo: self.slider.leadingAnchor),
            self.minimumDurationLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
        ])
        
       
        
        self.slider.minimumValue = 0.0
        self.slider.maximumValue = Float(self.player.duration)
        
        slider.addTarget(self, action: #selector(onSongSliderDragBegin), for: .touchDown)
        slider.addTarget(self, action: #selector(onSongSliderValueChange), for: .valueChanged)
        
        self.ff()
        self.updateTime()
        
        caDisplayLinkTimer = CADisplayLink(target: self, selector: #selector(onTimerFire(_:)))
        caDisplayLinkTimer.add(to: .main, forMode: .common)
        
        
    }
    
    func ff() {
        self.maximumDurationLabel.textColor = .secondaryLabel
        self.maximumDurationLabel.textAlignment = .right
        self.maximumDurationLabel.text = "00:00:00:00"
        
        self.view.addSubview(self.maximumDurationLabel)
        self.maximumDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.maximumDurationLabel.topAnchor.constraint(equalTo: self.slider.bottomAnchor, constant: 5),
            self.maximumDurationLabel.trailingAnchor.constraint(equalTo: self.slider.trailingAnchor),
            self.maximumDurationLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    func updateTime() {
        self.slider.value = Float(self.player.currentTime)
        self.minimumDurationLabel.text = self.stringFromTimeInterval(interval: self.player.currentTime)
        
        self.maximumDurationLabel.text = self.stringFromTimeInterval(interval: self.player.duration)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = NSInteger(interval)
        
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d:%0.2d",hours, minutes, seconds, ms)
    }
    
    @objc func onBarButtonTapped() {
        let vc = PlaylistViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .overCurrentContext
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.navigationController?.navigationBar.isTranslucent = true
        self.present(navigationController, animated: true)
    }
    
    @objc func onTimerFire(_ timer: CADisplayLink)
    {
        updateTime()
    }
    
    @objc func onSongSliderDragBegin() {
//        updateTime()
        self.player.pause()
        try! AVAudioSession.sharedInstance().setActive(false)
        self.isPlay = false
        caDisplayLinkTimer.isPaused = true
    }
    
    @objc func onSongSliderValueChange() {
        print("215")
        //delegate?.onSongSeekRequest(songPosition: Double(sender.value))
        print(self.slider.value)
        self.player.play()
        try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        self.isPlay = true
        player.currentTime = Double(self.slider.value)
        caDisplayLinkTimer.isPaused = false
    }
    
    @objc func onPlayTapped() {
        print(#function)
        
        switch self.isPlay {
        case true:
            self.player.pause()
            try! AVAudioSession.sharedInstance().setActive(false)
            self.isPlay = false
        case false:
            self.player.play()
            try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            self.isPlay = true
        }
        
//        if self.player.play() {
//            print(self.player.play())
//            self.player.pause()
//            try! AVAudioSession.sharedInstance().setActive(false)
//        } else {
//            print(self.player.play())
//            self.player.play()
//            try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
//        }
    }
}

