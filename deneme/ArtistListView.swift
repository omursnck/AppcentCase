import SwiftUI
import Kingfisher

struct ArtistListView: View {
    
    let artists: [Artist]
    
    var body: some View {
        List(artists, id: \.id) { artist in
            HStack {
                KFImage(URL(string: artist.picture))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                
                VStack(alignment: .leading) {
                    Text(artist.name)
                        .font(.headline)
                    
                    Text("\(artist.name) albums")
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("Artists")
    }
}
