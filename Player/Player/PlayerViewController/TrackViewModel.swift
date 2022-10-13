//
//  TrackViewModel.swift
//  Player
//
//  Created by pavel mishanin on 05.10.2022.
//

import UIKit

struct TrackViewModel {
    let title: String
    let artist: String
    let album: String
    let genre: String
    let artwork: Data
    let url: String
}

struct TrackRequest {
    let title: String
    let artist: String
    let album: String
    let genre: String
    let artwork: Data
    let url: String
    
    init(title: String,
         artist: String,
         album: String,
         genre: String,
         artwork: Data,
         url: String) {
        self.title = title
        self.artist = artist
        self.album = album
        self.genre = genre
        self.artwork = artwork
        self.url = url
    }
    
    init(viewModel: TrackViewModel) {
        self.title = viewModel.title
        self.artist = viewModel.artist
        self.album = viewModel.album
        self.genre = viewModel.genre
        self.artwork = viewModel.artwork
        self.url = viewModel.url
    }
    
    init(viewModel: TrackDTO) {
        self.title = viewModel.trackName ?? ""
        self.artist = viewModel.artistName ?? ""
        self.album = viewModel.currency ?? ""
        self.genre = viewModel.collectionName ?? ""
        self.artwork = Data()
        self.url = viewModel.previewUrl ?? ""
    }
}
