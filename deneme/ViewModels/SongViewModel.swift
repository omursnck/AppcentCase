//
//  SongViewModel.swift
//  deneme
//
//  Created by Ömür Şenocak on 9.05.2023.
import Foundation
import SwiftUI



class SongViewModel: ObservableObject {
    @Published var tracks: [Tracks] = []
    @ObservedObject private var userData = UserData() // Add UserData instance

    func fetchSongs(forAlbumId albumId: Int) async throws {
        let url = URL(string: "https://api.deezer.com/album/\(albumId)/tracks")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(TrackResponse.self, from: data)
        tracks = response.data
    }

    func toggleLike(for track: Tracks) {
        if userData.likedTracks.contains(where: { $0.id == track.id }) {
            userData.toggleLike(track)
        } else {
            userData.toggleLike(track)
        }
    }
    func updatePlayingState(with url: String) {
           // Update the playing state of the songs based on the provided URL
           for index in 0..<tracks.count {
               tracks[index].isPlaying = (tracks[index].preview == url)
           }
       }
}
    

    /*
    func Like(for track: Tracks) {
           if let index = tracks.firstIndex(where: { $0.id == track.id }) {
               tracks[index].isLiked = true
               print("\(track.title) Abdullah Ömür Şenocak")
               print("\(tracks[index].isLiked)")
           }
       }
    func unLike(for track: Tracks) {
           if let index = tracks.firstIndex(where: { $0.id == track.id }) {
               tracks[index].isLiked = false
               print("\(track.title) Abdullah Ömür Şenocak")
               print("\(tracks[index].isLiked)")
           }
       }
*/
    




// MARK: - Tracks

// MARK: - TracksDatum

struct TrackResponse: Decodable {
    var data: [Tracks]
    
}

// MARK: - Datum
struct Tracks: Identifiable, Codable {
    let id: Int
    let title, titleShort: String
    let link: String
    let duration: Int
    let preview: String
    let md5_image: String
    var isLiked: Bool? 
    var isPlaying: Bool = false // New property for playing state

    enum CodingKeys: String, CodingKey {
        case id
        case title = "title"
        case titleShort = "title_short"
        case link = "link"
        case duration
        case preview = "preview"
        case md5_image
        case isLiked = "isLiked"
       
    }
}


