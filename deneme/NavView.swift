//
//  TabView.swift
//  deneme
//
//  Created by Ömür Şenocak on 11.05.2023.
//

import SwiftUI


struct NavView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Content")
                }
            
            LikedSongsView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Liked Songs")
                }
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
}

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView()
    }
}



