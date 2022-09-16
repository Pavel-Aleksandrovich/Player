//
//  PlayerViewController.swift
//  Player
//
//  Created by pavel mishanin on 14.09.2022.
//

import UIKit

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
        self.configAppearance()
        self.makeConstraints()
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

// MARK: - Config Appearance
private extension PlayerViewController {
    
    func configAppearance() {
        self.configView()
        self.configBarButtonItem()
        self.configPosterImageView()
        self.configPlayImageView()
        self.configNextImageView()
        self.configLoopImageView()
        self.configPreviousImageView()
        self.configSlider()
        self.configMinimumDurationLabel()
        self.configMaximumDurationLabel()
        self.createDisplayLink()
    }
    
    func configView() {
        self.view.backgroundColor = .white
    }
    
    func configBarButtonItem() {
        let image = UIImage(systemName: "list.triangle")
        let item = UIBarButtonItem(image: image,
                                   style: .plain,
                                   target: self,
                                   action: #selector
                                   (self.onBarButtonTapped))
        item.tintColor = .black
        self.navigationItem.rightBarButtonItem = item
    }
    
    func configPosterImageView() {
        self.posterImageView.backgroundColor = .clear
        self.posterImageView.tintColor = .darkGray
        self.posterImageView.image = UIImage(systemName: "music.note")
        self.posterImageView.contentMode = .scaleAspectFit
    }
    
    func configPlayImageView() {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector
                                             (self.onPlayTapped))
        self.playImageView.addGestureRecognizer(gesture)
        self.playImageView.isUserInteractionEnabled = true
        self.playImageView.backgroundColor = .clear
        self.playImageView.tintColor = .darkGray
        self.playImageView.image = UIImage(systemName: "play.fill")
        self.playImageView.contentMode = .scaleAspectFill
    }
    
    func configNextImageView() {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector
                                             (onNextTapped))
        self.nextImageView.addGestureRecognizer(gesture)
        self.nextImageView.isUserInteractionEnabled = true
        self.nextImageView.backgroundColor = .clear
        self.nextImageView.tintColor = .darkGray
        self.nextImageView.image = UIImage(systemName: "forward.end.fill")
        self.nextImageView.contentMode = .scaleAspectFill
    }
    
    func configLoopImageView() {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector
                                              (self.onLoopTapped))
        self.loopImageView.addGestureRecognizer(gesture)
        self.loopImageView.isUserInteractionEnabled = true
        self.loopImageView.image = UIImage(systemName: "repeat")
        self.loopImageView.contentMode = .scaleAspectFill
        self.loopImageView.tintColor = .darkGray
    }
    
    func configPreviousImageView() {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector
                                             (self.onPreviousTapped))
        self.previousImageView.addGestureRecognizer(gesture)
        self.previousImageView.isUserInteractionEnabled = true
        self.previousImageView.backgroundColor = .clear
        self.previousImageView.tintColor = .darkGray
        self.previousImageView.image = UIImage(systemName: "backward.end.fill")
        self.previousImageView.contentMode = .scaleAspectFill
    }
    
    func configSlider() {
        self.slider.minimumTrackTintColor = .label.withAlphaComponent(0.5)
        self.slider.maximumTrackTintColor = .systemGray.withAlphaComponent(0.5)
        self.slider.thumbTintColor = .darkGray
        self.slider.minimumValue = 0.01
        
        self.slider.addTarget(self,
                              action: #selector(onSongSliderDragBegin),
                              for: .touchDown)
        self.slider.addTarget(self,
                              action: #selector(onSongSliderValueChange),
                              for: .valueChanged)
    }
    
    func configMinimumDurationLabel() {
        self.minimumDurationLabel.textColor = .secondaryLabel
        self.minimumDurationLabel.textAlignment = .left
        self.minimumDurationLabel.text = "00:00:00:00"
    }
    
    func configMaximumDurationLabel() {
        self.maximumDurationLabel.textColor = .secondaryLabel
        self.maximumDurationLabel.textAlignment = .right
        self.maximumDurationLabel.text = "00:00:00:00"
    }
    
    func createDisplayLink() {
       let caDisplayLinkTimer = CADisplayLink(target: self,
                                              selector: #selector
                                              (self.displayLinkChange))
        caDisplayLinkTimer.add(to: .main, forMode: .common)
    }
}

// MARK: - Actions
private extension PlayerViewController {
    
    @objc func onLoopTapped() {
        self.onLoopTappedHandler?()
    }
    
    @objc func onNextTapped() {
        self.onNextTappedHandler?()
    }
    
    @objc func onPreviousTapped() {
        self.onPreviousTappedHandler?()
    }
    
    @objc func onBarButtonTapped() {
        self.onPlaylistScreenTappedHandler?()
    }
    
    @objc func displayLinkChange() {
        self.onDisplayLinkChangeHandler?()
    }
    
    @objc func onSongSliderDragBegin() {
    }
    
    @objc func onSongSliderValueChange() {
        self.onSliderValueChangeHandler?()
    }
    
    @objc func onPlayTapped() {
        self.onPlayTappedHandler?()
    }
}

// MARK: - Make Constraints
private extension PlayerViewController {
    
    func makeConstraints() {
        self.makePosterImageViewConstraints()
        self.makePlayImageViewConstraints()
        self.makeNextImageViewConstraints()
        self.makeLoopImageViewConstraints()
        self.makePreviousImageViewConstraints()
        self.makeSliderConstraints()
        self.makeMinimumDurationLabelConstraints()
        self.makeMaximumDurationLabelConstraints()
    }
    
    func makePosterImageViewConstraints() {
        self.view.addSubview(self.posterImageView)
        self.posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.posterImageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            self.posterImageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            self.posterImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    func makePlayImageViewConstraints() {
        self.view.addSubview(self.playImageView)
        self.playImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.playImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.playImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.playImageView.heightAnchor.constraint(equalToConstant: 65),
            self.playImageView.widthAnchor.constraint(equalToConstant: 65),
        ])
    }
    
    func makeNextImageViewConstraints() {
        self.view.addSubview(self.nextImageView)
        self.nextImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.nextImageView.centerYAnchor.constraint(equalTo: self.playImageView.centerYAnchor),
            self.nextImageView.leadingAnchor.constraint(equalTo: self.playImageView.trailingAnchor, constant: 40),
            self.nextImageView.heightAnchor.constraint(equalToConstant: 40),
            self.nextImageView.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func makeLoopImageViewConstraints() {
        self.view.addSubview(self.loopImageView)
        self.loopImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.loopImageView.centerYAnchor.constraint(equalTo: self.playImageView.centerYAnchor),
            self.loopImageView.leadingAnchor.constraint(equalTo: self.nextImageView.trailingAnchor, constant: 20),
            self.loopImageView.heightAnchor.constraint(equalToConstant: 30),
            self.loopImageView.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func makePreviousImageViewConstraints() {
        self.view.addSubview(self.previousImageView)
        self.previousImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.previousImageView.centerYAnchor.constraint(equalTo: self.playImageView.centerYAnchor),
            self.previousImageView.trailingAnchor.constraint(equalTo: self.playImageView.leadingAnchor, constant: -40),
            self.previousImageView.heightAnchor.constraint(equalToConstant: 40),
            self.previousImageView.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func makeSliderConstraints() {
        self.view.addSubview(self.slider)
        self.slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.slider.bottomAnchor.constraint(equalTo: self.playImageView.topAnchor, constant: -50),
            self.slider.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            self.slider.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
        ])
    }
    
    func makeMinimumDurationLabelConstraints() {
        self.view.addSubview(self.minimumDurationLabel)
        self.minimumDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.minimumDurationLabel.topAnchor.constraint(equalTo: self.slider.bottomAnchor, constant: 5),
            self.minimumDurationLabel.leadingAnchor.constraint(equalTo: self.slider.leadingAnchor),
            self.minimumDurationLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
    
    func makeMaximumDurationLabelConstraints() {
        self.view.addSubview(self.maximumDurationLabel)
        self.maximumDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.maximumDurationLabel.topAnchor.constraint(equalTo: self.slider.bottomAnchor, constant: 5),
            self.maximumDurationLabel.trailingAnchor.constraint(equalTo: self.slider.trailingAnchor),
            self.maximumDurationLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}
