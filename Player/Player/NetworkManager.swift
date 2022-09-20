//
//  NetworkManager.swift
//  Player
//
//  Created by pavel mishanin on 20.09.2022.
//

import Foundation

protocol INetworkManager: AnyObject {
    func fetchSearchData(completion: @escaping(Result<[Track], Error>) -> ())
    func fetchImageData(from url: URL,
                        completion: @escaping(Data, URLResponse) -> ())
}

final class NetworkManager: INetworkManager {
    
    private enum ApiUrl {
        static let search =
        "https://itunes.apple.com/search?term=%@&media=music"
        static let album =
        "https://itunes.apple.com/lookup?id=%@&entity=song&limit=200"
    }
    
    func fetchSearchData(completion: @escaping(Result<[Track], Error>) -> ()) {
        
        let string = String(format: ApiUrl.search, "Korol i shut")
        let urlString = string.split(separator: " ").joined(separator: "%20")
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let albums = try JSONDecoder().decode(SearchModel<Track>.self,
                                                      from: data)
                completion(.success(albums.results))
            } catch let error {
                //completion Error
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchImageData(from url: URL,
                        completion: @escaping(Data, URLResponse) -> ()) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                //Completion with Result failure
                print(error.localizedDescription)
                return
            }
            guard let data = data, let response = response else {
                //completiom with Result failure
                print(error?.localizedDescription ?? "No error description")
                return }
            completion(data, response)
        }.resume()
    }
}

struct Track: Decodable {
    let artistId: Int?
    let collectionId: Int?
    let trackId: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let previewUrl: String?
    let albumPicture: String?
    let trackPrice: Double?
    let currency: String?
    
    enum CodingKeys: String, CodingKey {
        case artistId
        case collectionId
        case trackId
        case artistName
        case collectionName
        case trackName
        case previewUrl
        case albumPicture = "artworkUrl100"
        case trackPrice
        case currency
    }
}

struct SearchModel<T: Decodable>: Decodable {
    let resultCount: Int?
    let  results: [T]
}

