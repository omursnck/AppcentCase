import SwiftUI
import Combine

class UserData: ObservableObject {
    @Published var savedTracks: Set<Int> = []
    @Published var likedTracks: [Tracks] = [] // Add the 'likedTracks' property
    @Published var currentPlayingUrl: String? // Store the URL of the currently playing song

    static let shared = UserData()
    private let likedTracksKey = "LikedTracks"
    
    func saveLikedTracks() {
         let encoder = JSONEncoder()
         if let encodedData = try? encoder.encode(likedTracks) {
             UserDefaults.standard.set(encodedData, forKey: likedTracksKey)
         }
     }

     func loadLikedTracks() {
         if let encodedData = UserDefaults.standard.data(forKey: likedTracksKey) {
             let decoder = JSONDecoder()
             if let decodedData = try? decoder.decode([Tracks].self, from: encodedData) {
                 likedTracks = decodedData
             }
         }
     }
    func toggleSave(_ track: Tracks) {
        if savedTracks.contains(track.id) {
            savedTracks.remove(track.id)
        } else {
            savedTracks.insert(track.id)
        }
        saveTracks()
    }

    func toggleLike(_ track: Tracks) {
        if let index = likedTracks.firstIndex(where: { $0.id == track.id }) {
            likedTracks.remove(at: index)
        } else {
            likedTracks.append(track)
        }
        saveLikedTracks()
    }

    private func saveTracks() {
        UserDefaults.standard.set(Array(savedTracks), forKey: "SavedTracks")
    }

   

    private func loadSavedTracks() {
        if let savedTrackIds = UserDefaults.standard.array(forKey: "SavedTracks") as? [Int] {
            savedTracks = Set(savedTrackIds)
        }
    }

 

    func loadUserData() {
        loadSavedTracks()
        loadLikedTracks()
    }
}
