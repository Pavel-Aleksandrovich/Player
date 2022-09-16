//
//  PlaylistViewController.swift
//  Player
//
//  Created by pavel mishanin on 14.09.2022.
//

import UIKit

protocol IPlaylistViewController: AnyObject {
    var onCellTappedHandler: ((Int) -> ())? { get set }
    func reloadData()
}

final class PlaylistViewController: UIViewController {
    
    private let presenter: IPlaylistPresenter
    private let mainView = PlaylistView()
    
    var onCellTappedHandler: ((Int) -> ())?
    
    init(presenter: IPlaylistPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.onViewAttached(controller: self)
        self.mainView.tableViewDataSource = self
        self.mainView.tableViewDelegate = self
    }
}

extension PlaylistViewController: IPlaylistViewController {
    
    func reloadData() {
        self.mainView.reloadData()
    }
}

extension PlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        self.presenter.numberOfRowsInSection()
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlaylistTableCell.id,
            for: indexPath) as? PlaylistTableCell
        else { return UITableViewCell() }
        
        let song = self.presenter.getSongById(indexPath.row)
        cell.set(song)
        
        cell.select(self.presenter.getSelectedSong(indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.onCellTappedHandler?(indexPath.row)
        print(#function)
    }
}
