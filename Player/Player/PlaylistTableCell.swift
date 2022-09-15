//
//  PlaylistTableCell.swift
//  Player
//
//  Created by pavel mishanin on 15.09.2022.
//

import UIKit

final class PlaylistTableCell: UITableViewCell {
    
    static let id = String(describing: PlaylistTableCell.self)
    
    private let currencyNameLabel = UILabel()
    private let charCodeLabel = UILabel()
    private let flagImageView = UIImageView()
    let favoriteImageView = UIImageView()
    
    var onFavoriteImageTappedHandler: (() -> ())?
    
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
}

// MARK: - Config Appearance
private extension PlaylistTableCell {
    
    func configAppearance() {
        self.configView()
        self.configFlagImageView()
        self.configFavoriteImageView()
        self.configCharCodeLabel()
        self.configCurrencyNameLabel()
        self.configTapGestureRecognizer()
    }
    
    func configView() {
        self.selectionStyle = .none
    }
        
    func configFlagImageView() {
        self.flagImageView.clipsToBounds = true
        self.flagImageView.layer.borderWidth = 1
        self.flagImageView.layer.cornerRadius = 25
        self.flagImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.flagImageView.contentMode = .scaleAspectFill
    }
    
    func configFavoriteImageView() {
        self.favoriteImageView.tintColor = .darkGray
        self.favoriteImageView.contentMode = .scaleAspectFill
        self.favoriteImageView.isUserInteractionEnabled = true
        self.favoriteImageView.accessibilityIdentifier = "Favorite"
    }
    
    func configCharCodeLabel() {
        self.charCodeLabel.textColor = .systemGray
    }
    
    func configCurrencyNameLabel() {
        self.currencyNameLabel.font = UIFont.boldSystemFont(ofSize: 19)
    }
    
    func configTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector
                                                (self.onFavoriteImageTapped))
        self.favoriteImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func onFavoriteImageTapped() {
        self.onFavoriteImageTappedHandler?()
    }
}

// MARK: - Make Constraints
private extension PlaylistTableCell {
    
    func makeConstraints() {
        self.makeFlagImageViewConstraints()
        self.makeFavoriteImageViewConstraints()
        self.makeCurrencyNameLabelConstraints()
        self.makeCharCodeLabelConstraints()
    }
    
    func makeFlagImageViewConstraints() {
        self.addSubview(self.flagImageView)
        self.flagImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.flagImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.flagImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.flagImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            self.flagImageView.widthAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    func makeFavoriteImageViewConstraints() {
        self.contentView.addSubview(self.favoriteImageView)
        self.favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.favoriteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.favoriteImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            self.favoriteImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            self.favoriteImageView.widthAnchor.constraint(equalToConstant: self.bounds.height - 10)
        ])
    }
    
    func makeCurrencyNameLabelConstraints() {
        self.addSubview(self.currencyNameLabel)
        self.currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.currencyNameLabel.leadingAnchor.constraint(equalTo: self.flagImageView.trailingAnchor, constant: 5),
            self.currencyNameLabel.trailingAnchor.constraint(equalTo: self.favoriteImageView.leadingAnchor),
            self.currencyNameLabel.topAnchor.constraint(equalTo: self.centerYAnchor),
            self.currencyNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func makeCharCodeLabelConstraints() {
        self.addSubview(self.charCodeLabel)
        self.charCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.charCodeLabel.leadingAnchor.constraint(equalTo: self.flagImageView.trailingAnchor, constant: 5),
            self.charCodeLabel.trailingAnchor.constraint(equalTo: self.favoriteImageView.leadingAnchor),
            self.charCodeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.charCodeLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
