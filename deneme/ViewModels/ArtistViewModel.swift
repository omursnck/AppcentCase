import Foundation

class ArtistViewModel: ObservableObject {
    
    @Published var artists: [Artist] = []
    
    func fetchArtists(forGenreId genreId: Int) async throws {
        let url = URL(string: "https://api.deezer.com/genre/\(genreId)/artists")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ArtistResponse.self, from: data)
        artists = response.data
    }
    
}

struct ArtistResponse: Codable {
    let data: [Artist]
}

struct Artist: Codable, Identifiable {
    let id: Int
    let name: String
    let picture: String
    let pictureSmall, pictureMedium, pictureBig, pictureXl: String
    let tracklist: String
  
    

    enum CodingKeys: String, CodingKey {
        case id, name, picture
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXl = "picture_xl"
        case tracklist
    
    }
}
