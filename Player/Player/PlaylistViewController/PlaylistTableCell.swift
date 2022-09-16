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
    
    func set(_ model: String) {
        self.currencyNameLabel.text = model
    }
    
    func select(_ string: String) {
        self.flagImageView.image = UIImage(systemName: string)
    }
}

// MARK: - Config Appearance
private extension PlaylistTableCell {
    
    func configAppearance() {
        self.configView()
        self.configFlagImageView()
        self.configCharCodeLabel()
        self.configCurrencyNameLabel()
    }
    
    func configView() {
//        self.selectionStyle = .none
    }
        
    func configFlagImageView() {
        self.flagImageView.clipsToBounds = true
        self.flagImageView.layer.borderWidth = 1
        self.flagImageView.layer.cornerRadius = 25
        self.flagImageView.layer.borderColor = UIColor.darkGray.cgColor
        self.flagImageView.contentMode = .scaleAspectFit
        self.flagImageView.tintColor = .darkGray
    }
    
    func configCharCodeLabel() {
        self.charCodeLabel.textColor = .systemGray
    }
    
    func configCurrencyNameLabel() {
        self.currencyNameLabel.textColor = .black
//        self.currencyNameLabel.font = UIFont.boldSystemFont(ofSize: 19)
    }
}

// MARK: - Make Constraints
private extension PlaylistTableCell {
    
    func makeConstraints() {
        self.makeFlagImageViewConstraints()
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
    
    func makeCurrencyNameLabelConstraints() {
        self.addSubview(self.currencyNameLabel)
        self.currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.currencyNameLabel.leadingAnchor.constraint(equalTo: self.flagImageView.trailingAnchor, constant: 5),
            self.currencyNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.currencyNameLabel.topAnchor.constraint(equalTo: self.centerYAnchor),
            self.currencyNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func makeCharCodeLabelConstraints() {
        self.addSubview(self.charCodeLabel)
        self.charCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.charCodeLabel.leadingAnchor.constraint(equalTo: self.flagImageView.trailingAnchor, constant: 5),
            self.charCodeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.charCodeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.charCodeLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
