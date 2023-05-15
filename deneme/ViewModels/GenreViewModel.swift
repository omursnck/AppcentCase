import Foundation

class GenreViewModel: ObservableObject {
    
    @Published var genres = [Genre]()
    
    func fetchGenres() async throws {
        guard let url = URL(string: "https://api.deezer.com/genre") else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let genres = try decoder.decode(Welcome.self, from: data)
        self.genres = genres.data
    }
    
}
