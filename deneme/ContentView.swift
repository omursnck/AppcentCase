import SwiftUI
import Kingfisher
import AVKit

struct ContentView: View {
    
    @StateObject var viewModel = GenreViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible(minimum: 100)), GridItem(.flexible(minimum: 100))], spacing: 20) {
                    ForEach(viewModel.genres, id: \.id) { genre in
                        NavigationLink(destination: ArtistListView(genreId: genre.id)) {
                            VStack {
                                                     KFImage(URL(string: genre.pictureMedium))
                                                         .resizable()
                                                         .aspectRatio(contentMode: .fit)
                                                         .frame(width: 180, height: 180)
                                                         .cornerRadius(10)
                                                     Text(genre.name)
                                                         .font(.headline)
                                                         .multilineTextAlignment(.center)
                                                         .lineLimit(2)
                                                         .padding(.top, 5)
                                                         .padding(.horizontal, 10)
                                                 }
                        }
                    }
                    
                }
                .foregroundColor(.black)
                .navigationBarTitle("Genres")
            }
        }
        .task {
            do {
                try await viewModel.fetchGenres()
            } catch {
                print("Error fetching genres: \(error)")
            }
        }
    }
    
}

struct ArtistListView: View {
    
    @StateObject var viewModel = ArtistViewModel()
    let genreId: Int
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(minimum: 100)), GridItem(.flexible(minimum: 100))], spacing: 20) {
                ForEach(viewModel.artists, id: \.id) { artist in
                    NavigationLink(destination: AlbumListView(artist: artist, artistId: artist.id)) {
                        VStack {
                      
                            KFImage(URL(string: artist.pictureMedium))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 180, height: 180)
                                .cornerRadius(10)
                            Text(artist.name)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .padding(.top, 5)
                                .padding(.horizontal, 10)
                        }
                    }
                }
            }.foregroundColor(.black)
            .navigationBarTitle("Artists")
            .task {
                do {
                    try await viewModel.fetchArtists(forGenreId: genreId)
                } catch {
                    print("Error fetching artists: \(error)")
                }
        }
        }
    }
    
}


struct AlbumListView: View {
    // ...
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @StateObject var viewModel = AlbumViewModel()
    let artist: Artist
    let artistId: Int
    
    var body: some View {
        ScrollView {
            KFImage(URL(string: artist.picture))
                .clipShape(Circle())
            
            LazyVStack {
                ForEach(viewModel.albums, id: \.id) { album in
                    NavigationLink(destination: SongListView(albumId: album.id, albumler: album)) {
                        VStack(alignment: .leading) {
                            HStack {
                                KFImage(URL(string: album.coverMedium))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                                VStack(alignment: .leading) {
                                    Text(album.title)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .padding(.top, 5)
                           
                                    
                                    Text(formatReleaseDate(album.releaseDate))
                                        .font(.footnote)
                                }.padding()
                                
                                Spacer()
                            }
                            .padding()
                        }
                    }
                 
                    Divider()
                }
            }
            .foregroundColor(.black)
            .navigationBarTitle(artist.name)
            .task {
                do {
                    try await viewModel.fetchAlbums(forArtist: artist)
                } catch {
                    print("Error fetching albums: \(error)")
                }
            }
        }
    }
    
    func formatReleaseDate(_ dateString: String) -> String {
        if let date = dateFormatter.date(from: dateString) {
            let formattedDate = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
            return formattedDate
        }
        return ""
    }
}
struct SongListView: View {
    @EnvironmentObject private var userData: UserData // Use the injected UserData
    @StateObject private var viewModel = SongViewModel()

    let albumId: Int
    let albumler: Album
    @State private var currentPlayer: AVPlayer?
  
    func playSong(with url: String) {
        guard let audioUrl = URL(string: url) else {
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
            return
        }

        if let currentPlayer = currentPlayer, let currentPlayingUrl = userData.currentPlayingUrl {
            if currentPlayingUrl == url {
                // The tapped song is already playing, so pause it
                currentPlayer.pause()
                userData.currentPlayingUrl = nil // Reset the currentPlayingUrl
            } else {
                // Another song is playing, so replace it with the tapped song
                currentPlayer.replaceCurrentItem(with: AVPlayerItem(url: audioUrl))
                currentPlayer.play()
                userData.currentPlayingUrl = url // Update the currentPlayingUrl
            }
        } else {
            // No song is currently playing, so play the tapped song
            currentPlayer = AVPlayer(playerItem: AVPlayerItem(url: audioUrl))
            currentPlayer?.play()
            userData.currentPlayingUrl = url // Update the currentPlayingUrl
        }
    }

    
    func formatDuration(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.tracks) { track in
                    VStack(alignment: .leading) {
                        VStack {
                            HStack {
                                Button(action: {
                                    if let currentPlayer = currentPlayer {
                                        currentPlayer.pause()
                                    }
                                    playSong(with: track.preview)
                                }, label: {
                                    HStack {
                                        KFImage(URL(string: albumler.coverMedium))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())

                                        VStack(alignment: .leading) {
                                            Text(track.title)
                                                .font(.headline)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(2)
                                                .padding(.top, 5)

                                            Text(formatDuration(track.duration))
                                                .font(.footnote)
                                                .padding(.top)
                                        }
                                    }
                                    .foregroundColor(track.isPlaying ? .blue : .black) // Change the foreground color based on isPlaying
                                })

                                Spacer()

                                Button(action: {
                                    if track.isLiked ?? false {
                                        userData.toggleLike(track) // Toggle like using UserData
                                    } else {
                                        userData.toggleLike(track) // Toggle like using UserData
                                    }
                                }) {
                                    Image(systemName: (userData.likedTracks.contains(where: { $0.id == track.id })) ? "heart.fill" : "heart")
                                        .foregroundColor((userData.likedTracks.contains(where: { $0.id == track.id })) ? .red : .black) // Change color based on isLiked
                                        .padding(.trailing)
                                        .font(.system(size: 20))
                                }
                            }
                        }
                    }
                    .padding()
                    Divider()
                }
                .navigationBarTitle(albumler.title)
                .task {
                    do {
                        try await viewModel.fetchSongs(forAlbumId: albumId)
                    } catch {
                        print("Error fetching songs: \(error)")
                    }
                }
            }
        }
        .environmentObject(userData) // Inject UserData into the environment
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



