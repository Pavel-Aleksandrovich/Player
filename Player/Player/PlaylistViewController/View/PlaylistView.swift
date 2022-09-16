//
//  PlaylistView.swift
//  Player
//
//  Created by pavel mishanin on 16.09.2022.
//

import UIKit

final class PlaylistView: UIView {
    
    private let tableView = UITableView()
    
    var tableViewDelegate: UITableViewDelegate? {
        get {
            nil
        }
        set {
            self.tableView.delegate = newValue
        }
    }
    
    var tableViewDataSource: UITableViewDataSource? {
        get {
            nil
        }
        set {
            self.tableView.dataSource = newValue
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.configAppearance()
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlaylistView {
    
    func reloadData() {
        self.tableView.reloadData()
    }
}

// MARK: - Config Appearance
private extension PlaylistView {
    
    func configAppearance() {
        self.configView()
        self.configTableView()
    }
    
    func configView() {
        self.backgroundColor = .white
    }
    
    func configTableView() {
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(PlaylistTableCell.self,
                                forCellReuseIdentifier: PlaylistTableCell.id)
    }
}

// MARK: - Make Constraints
private extension PlaylistView {
    
    func makeConstraints() {
        self.makeTableViewConstraints()
    }
    
    func makeTableViewConstraints() {
        self.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: self.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
