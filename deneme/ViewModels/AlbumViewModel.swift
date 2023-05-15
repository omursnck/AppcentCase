import Foundation

class AlbumViewModel: ObservableObject {
    
    @Published var albums: [Album] = []
    @Published var artist: [Artist] = []
    
    func fetchAlbums(forArtist artist: Artist) async throws {
        let url = URL(string: "https://api.deezer.com/artist/\(artist.id)/albums")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(AlbumResponse.self, from: data)
        albums = response.data
        
    }
}


// MARK: - Welcome

struct Albumler: Codable {
    let data: [Album]
    let artist: [Artist]
    let total: Int
    let next: String
}

// MARK: - Datum
struct Album: Codable {
    let id: Int
    let title: String
    let link, cover: String
    let coverSmall, coverMedium, coverBig, coverXl: String
    let md5Image: String
    let genreID, fans: Int
    let releaseDate: String
    let recordType: String
    let tracklist: String
    let explicitLyrics: Bool
  

    enum CodingKeys: String, CodingKey {
        case id, title, link, cover
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case coverXl = "cover_xl"
        case md5Image = "md5_image"
        case genreID = "genre_id"
        case fans
        case releaseDate = "release_date"
        case recordType = "record_type"
        case tracklist
        case explicitLyrics = "explicit_lyrics"
    }
}


struct AlbumResponse: Codable {
    let data: [Album]
}
