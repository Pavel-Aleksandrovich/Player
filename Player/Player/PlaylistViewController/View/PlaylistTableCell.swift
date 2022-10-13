//
//  PlaylistTableCell.swift
//  Player
//
//  Created by pavel mishanin on 15.09.2022.
//

import UIKit

final class PlaylistTableCell: UITableViewCell {
    
    static let id = String(describing: PlaylistTableCell.self)
    
    private let songNameLabel = UILabel()
    private let posterImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configAppearance()
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlaylistTableCell {
    
    func set(_ model: TrackRequest) {
        self.songNameLabel.text = model.title
        self.posterImageView.image = UIImage(data: model.artwork)
    }
    
    func select(_ image: UIImage?) {
        self.posterImageView.image = image
    }
}

// MARK: - Config Appearance
private extension PlaylistTableCell {
    
    func configAppearance() {
        self.configFlagImageView()
        self.configSongNameLabel()
    }
    
    func configFlagImageView() {
        self.posterImageView.clipsToBounds = true
        self.posterImageView.layer.borderWidth = 1
        self.posterImageView.layer.cornerRadius = 25
        self.posterImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.posterImageView.contentMode = .scaleAspectFit
        self.posterImageView.tintColor = .darkGray
    }
    
    func configSongNameLabel() {
        self.songNameLabel.textColor = .black
    }
}

// MARK: - Make Constraints
private extension PlaylistTableCell {
    
    func makeConstraints() {
        self.makePosterImageViewConstraints()
        self.makeSongNameLabelConstraints()
    }
    
    func makePosterImageViewConstraints() {
        self.addSubview(self.posterImageView)
        self.posterImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.posterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            self.posterImageView.widthAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func makeSongNameLabelConstraints() {
        self.addSubview(self.songNameLabel)
        self.songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.songNameLabel.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 5),
            self.songNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.songNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.songNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
