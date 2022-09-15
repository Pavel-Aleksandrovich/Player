//
//  PlaylistViewController.swift
//  Player
//
//  Created by pavel mishanin on 14.09.2022.
//

import UIKit

final class PlaylistViewController: UIViewController {
    
    private let tableView = UITableView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
//        self.modalPresentationStyle = .overCurrentContext
//        self.modalTransitionStyle = .coverVertical
//        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "fdffsfds"
    }
    
    func configTableView() {
            self.tableView.backgroundColor = .clear
//            self.tableView.separatorStyle = .none
            self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
            self.tableView.register(PlaylistTableCell.self,
                                    forCellReuseIdentifier: PlaylistTableCell.id)
        }
    
    func makeTableViewConstraints() {
        self.view.addSubview(self.tableView)
            self.tableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            ])
        }
}

extension PlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
    
}
