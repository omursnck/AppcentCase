
import SwiftUI
import Kingfisher
import AVKit
import CryptoKit
import URLImage

extension String {
    func dataFromMD5() -> Data? {
        let md5 = Insecure.MD5.hash(data: Data(self.utf8))
        return Data(md5)
    }
}

struct LikedSongsView: View {
    @EnvironmentObject private var userData: UserData
    @State private var currentPlayer: AVPlayer?
    @State private var isPlaying: Bool = false

    func formatDuration(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(userData.likedTracks) { track in
                    HStack {
                        
                            let md5String = track.md5_image
                            if let imageData = md5String.dataFromMD5(),
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.black)
                            } else {
                                Image(systemName: "music.note")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.black)
                            }
                        
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
                        .foregroundColor(.black)

                        Spacer()

                        Button(action: {
                            userData.toggleLike(track)
                        }, label: {
                            Image(systemName: (userData.likedTracks.contains(where: { $0.id == track.id })) ? "heart.fill" : "heart")
                                .foregroundColor((userData.likedTracks.contains(where: { $0.id == track.id })) ? .red : .black)
                                .padding(.trailing)
                                .font(.system(size: 20))
                        })
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
            }
            .navigationBarTitle("Liked Songs")
            .onAppear {
                userData.loadLikedTracks()
            }
        }
    }

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

        let playerItem = AVPlayerItem(url: audioUrl)
        currentPlayer?.replaceCurrentItem(with: playerItem)
        currentPlayer?.play()
    }
}

/*

import SwiftUI
import Kingfisher
import AVKit
import CryptoKit
import URLImage

extension String {
    func dataFromMD5() -> Data? {
        let md5 = Insecure.MD5.hash(data: Data(self.utf8))
        return Data(md5)
    }
}

struct LikedSongsView: View {
    @EnvironmentObject private var userData: UserData
    @State private var player: AVPlayer?
    @State private var isPlaying: Bool = false

    
    func formatDuration(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
 
  

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(userData.likedTracks) { track in
                    HStack {
                        Button(action: {
                            playSong(with: track.preview)
                            isPlaying.toggle()
                            
                        }, label: {
                            
                            let md5String = track.md5_image
                            if let imageData = md5String.dataFromMD5(),
                                       let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } else {
                                        Image(systemName: "music.note")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.black)
                                    }
                             
           
                        })
                      

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
                        .foregroundColor(.black)

                        Spacer()

                        Button(action: {
                            userData.toggleLike(track)
                        }, label: {
                            Image(systemName: (userData.likedTracks.contains(where: { $0.id == track.id })) ? "heart.fill" : "heart")
                                .foregroundColor((userData.likedTracks.contains(where: { $0.id == track.id })) ? .red : .black)
                                .padding(.trailing)
                                .font(.system(size: 20))
                        })
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }

            }
            .navigationBarTitle("Liked Songs")

            .onAppear {
                userData.loadLikedTracks()
        }
        }
    }
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

        let playerItem = AVPlayerItem(url: audioUrl)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }

}

*/
