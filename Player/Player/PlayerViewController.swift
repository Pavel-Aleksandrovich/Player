//
//  PlayerViewController.swift
//  Player
//
//  Created by pavel mishanin on 14.09.2022.
//

import UIKit
import AVFoundation

enum LoopState: Int {
    case off = 0
    case on = -1
}

protocol IPlayerViewController: AnyObject {
    var onLoopTappedHandler: (() -> ())? { get set }
    var onNextTappedHandler: (() -> ())? { get set }
    var onPreviousTappedHandler: (() -> ())? { get set }
    var onDisplayLinkChangeHandler: (() -> ())? { get set }
    var maximumDurationLabelText: String? { get set }
    var minimumDurationLabelText: String? { get set }
    var onPlaylistScreenTappedHandler: (() -> ())? { get set }
    var onPlayTappedHandler: (() -> ())? { get set }
    var onSliderValueChangeHandler: (() -> ())? { get set }
    var sliderValue: Float { get set }
    var sliderMaximumValue: Float { get set }
    func setLoopImage(string: String)
    func setPlayImage(string: String)
}

final class PlayerViewController: UIViewController {

    private let presenter: IPlayerPresenter
    
    var onLoopTappedHandler: (() -> ())?
    var onNextTappedHandler: (() -> ())?
    var onPreviousTappedHandler: (() -> ())?
    var onDisplayLinkChangeHandler: (() -> ())?
    var onPlaylistScreenTappedHandler: (() -> ())?
    var onPlayTappedHandler: (() -> ())?
    var onSliderValueChangeHandler: (() -> ())?
    
    var maximumDurationLabelText: String? {
        get {
            self.maximumDurationLabel.text
        }
        set {
            self.maximumDurationLabel.text = newValue
        }
    }
    
    var minimumDurationLabelText: String? {
        get {
            self.minimumDurationLabel.text
        }
        set {
            self.minimumDurationLabel.text = newValue
        }
    }
    
    var sliderValue: Float {
        get {
            self.slider.value
        }
        set {
            self.slider.value = newValue
        }
    }
    
    var sliderMaximumValue: Float {
        get {
            self.slider.maximumValue
        }
        set {
            self.slider.maximumValue = newValue
        }
    }
    
    private let playImageView = UIImageView()
    private let nextImageView = UIImageView()
    private let previousImageView = UIImageView()
    private let posterImageView = UIImageView()
    private let slider = UISlider()
    private let loopImageView = UIImageView()
    private let minimumDurationLabel = UILabel()
    private let maximumDurationLabel = UILabel()
    
    private var songsArray: [String] = ["11", "22", "33"]
//    private var player = AVAudioPlayer()
    private var index = Int()
    private var loopState: LoopState = .off
    
    init(presenter: IPlayerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.onViewAttached(controller: self)
        
        self.view.backgroundColor = .white
        
        let image = UIImage(systemName: "list.triangle")
        let item = UIBarButtonItem(image: image,
                                   style: .plain,
                                   target: self,
                                   action: #selector
                                   (self.onBarButtonTapped))
        item.tintColor = .black
        self.navigationItem.rightBarButtonItem = item
        
        self.posterImageView.backgroundColor = .clear
        self.posterImageView.tintColor = .darkGray
        self.posterImageView.image = UIImage(systemName: "music.note")
        self.posterImageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(self.posterImageView)
        self.posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.posterImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            self.posterImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            self.posterImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
        
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(onPlayTapped))
        self.playImageView.addGestureRecognizer(gesture)
        self.playImageView.isUserInteractionEnabled = true
        self.playImageView.backgroundColor = .clear
        self.playImageView.tintColor = .darkGray
        self.playImageView.image = UIImage(systemName: "play.fill")
        self.playImageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(self.playImageView)
        self.playImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.playImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.playImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.playImageView.heightAnchor.constraint(equalToConstant: 65),
            self.playImageView.widthAnchor.constraint(equalToConstant: 65),
        ])
        
        self.nextImageView.backgroundColor = .clear
        self.nextImageView.tintColor = .darkGray
        self.nextImageView.image = UIImage(systemName: "forward.end.fill")
        self.nextImageView.contentMode = .scaleAspectFill
        
        let gestureN = UITapGestureRecognizer(target: self,
                                             action: #selector(onNextTapped))
        self.nextImageView.addGestureRecognizer(gestureN)
        self.nextImageView.isUserInteractionEnabled = true
        
        self.view.addSubview(self.nextImageView)
        self.nextImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.nextImageView.centerYAnchor.constraint(equalTo: self.playImageView.centerYAnchor),
            self.nextImageView.leadingAnchor.constraint(equalTo: self.playImageView.trailingAnchor, constant: 40),
            self.nextImageView.heightAnchor.constraint(equalToConstant: 40),
            self.nextImageView.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        let gestureL = UITapGestureRecognizer(target: self,
                                             action: #selector(onLoopTapped))
        self.loopImageView.addGestureRecognizer(gestureL)
        self.loopImageView.isUserInteractionEnabled = true
        self.loopImageView.image = UIImage(systemName: "repeat")
        self.loopImageView.contentMode = .scaleAspectFill
        self.loopImageView.tintColor = .darkGray
        
        self.view.addSubview(self.loopImageView)
        self.loopImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.loopImageView.centerYAnchor.constraint(equalTo: self.playImageView.centerYAnchor),
            self.loopImageView.leadingAnchor.constraint(equalTo: self.nextImageView.trailingAnchor, constant: 20),
            self.loopImageView.heightAnchor.constraint(equalToConstant: 30),
            self.loopImageView.widthAnchor.constraint(equalToConstant: 30),
        ])
        
        let gestureP = UITapGestureRecognizer(target: self,
                                             action: #selector(onPreviousTapped))
        self.previousImageView.addGestureRecognizer(gestureP)
        self.previousImageView.isUserInteractionEnabled = true
        
        self.previousImageView.backgroundColor = .clear
        self.previousImageView.tintColor = .darkGray
        self.previousImageView.image = UIImage(systemName: "backward.end.fill")
        self.previousImageView.contentMode = .scaleAspectFill
        
        self.view.addSubview(self.previousImageView)
        self.previousImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.previousImageView.centerYAnchor.constraint(equalTo: self.playImageView.centerYAnchor),
            self.previousImageView.trailingAnchor.constraint(equalTo: self.playImageView.leadingAnchor, constant: -40),
            self.previousImageView.heightAnchor.constraint(equalToConstant: 40),
            self.previousImageView.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        self.slider.minimumTrackTintColor = .label.withAlphaComponent(0.5)
        self.slider.maximumTrackTintColor = .systemGray.withAlphaComponent(0.5)
        self.slider.thumbTintColor = .darkGray
        self.slider.minimumValue = 0.0
        
        slider.addTarget(self, action: #selector(onSongSliderDragBegin), for: .touchDown)
        slider.addTarget(self, action: #selector(onSongSliderValueChange), for: .valueChanged)
        
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
        
        createDisplayLink()
        
       
        
        self.ff()
        
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(didEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
//        
    }
    
    @objc func didEnd() {
        print(#function)
        print("#function")
        print("#function")
        print("#function")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
//    func config() {
//        if self.songsArray.count > 0 {
//            let string = Bundle.main.path(forResource: songsArray[self.index],
//                                          ofType: "mp3")
//
//            guard let string = string else { return }
//
//            let url = URL(string: string)
//
//            guard let url = url else { print("url error")
//                return }
//
//            do {
//                self.player = try AVAudioPlayer(contentsOf: url)
//                self.player.play()
//            } catch {
//                print(error.localizedDescription)
//            }
//
//            self.player.numberOfLoops = self.loopState.rawValue
//            self.slider.maximumValue = Float(self.player.duration)
//        }
//    }
    
    func createDisplayLink() {
       let caDisplayLinkTimer = CADisplayLink(target: self,
                                           selector: #selector(onTimerFire))
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
    
    @objc func onLoopTapped() {
//        switch self.loopState {
//        case .off:
//            self.loopState = .on
//            self.loopImageView.image = UIImage(systemName: "repeat.circle.fill")
//            self.player.numberOfLoops = self.loopState.rawValue
//        case .on:
//            self.loopState = .off
//            self.loopImageView.image = UIImage(systemName: "repeat")
//            self.player.numberOfLoops = self.loopState.rawValue
//        }
        
        self.onLoopTappedHandler?()
        print(#function)
    }
    
    @objc func onNextTapped() {
//        self.index += 1
//
//        if self.index == self.songsArray.count {
//            self.index = 0
//        }
        
//        self.config()
        
        self.onNextTappedHandler?()
        print(#function)
    }
    
    @objc func onPreviousTapped() {
//        let count = self.songsArray.count
//
//        if count != 0 {
//            self.index -= 1
//        }
//
//        if self.index < 0 {
//            self.index = count - 1
//        }
        
//        self.config()
        
        self.onPreviousTappedHandler?()
        print(#function)
    }
    
//    func stringFromTimeInterval(interval: TimeInterval) -> String {
//
//        let ti = NSInteger(interval)
//
//        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
//        let seconds = ti % 60
//        let minutes = (ti / 60) % 60
//        let hours = (ti / 3600)
//
//        return String(format: "%0.2d:%0.2d:%0.2d:%0.2d",hours, minutes, seconds, ms)
//    }
    
    @objc func onBarButtonTapped() {
        self.onPlaylistScreenTappedHandler?()
        print(#function)
    }
    
    @objc func onTimerFire() {
//        self.slider.value = Float(self.player.currentTime)
//        self.minimumDurationLabel.text = self.stringFromTimeInterval(interval: self.player.currentTime)
//
//        self.maximumDurationLabel.text = self.stringFromTimeInterval(interval: self.player.duration)
        
        self.onDisplayLinkChangeHandler?()
    }
    
    @objc func onSongSliderDragBegin() {
//        self.player.pause()
    }
    
    @objc func onSongSliderValueChange() {
//        self.player.play()
//        player.currentTime = Double(self.slider.value)
        
        self.onSliderValueChangeHandler?()
    }
    
    @objc func onPlayTapped() {
        print(#function)
        self.onPlayTappedHandler?()
//        switch self.player.isPlaying {
//        case true:
//            self.player.pause()
//
//
//            try! AVAudioSession.sharedInstance().setActive(false)
//
//
//            self.playImageView.image = UIImage(systemName: "play.fill")
//        case false:
//
//
//            try! AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
//
//
//            self.player.play()
//            self.playImageView.image = UIImage(systemName: "pause.fill")
//
//            if self.player.currentTime == 0 {
//                self.config()
//            }
//
//        }
        
    }
}

extension PlayerViewController: IPlayerViewController {
    
    func setLoopImage(string: String) {
        self.loopImageView.image = UIImage(systemName: string)
    }
    
    func setPlayImage(string: String) {
        self.playImageView.image = UIImage(systemName: string)
    }
}

