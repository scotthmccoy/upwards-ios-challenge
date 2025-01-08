//
//  TopAlbumsView.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import SwiftUI

struct TopAlbumsView: View {
    
    @StateObject var topAlbumsViewModel = TopAlbumsViewModel()
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView() {
            LazyVGrid(
               columns: [
                   GridItem(.flexible()),
                   GridItem(.flexible())
               ],
               spacing: 10
            ) {
                ForEach(topAlbumsViewModel.albums, id: \.self) { album in
                    AlbumCellView(album: album)
                }
            }
            .padding(10)
        }
        .background(Color("Background"))
        .navigationBarTitle("Top Albums", displayMode: .inline)
        
        // Nav Bar Text Color
        .toolbarColorScheme(.dark, for: .navigationBar)
        
        // Nav Bar Background color
        .toolbarBackground(
            Color("NavBar"),
            for: .navigationBar
        )
        .toolbarBackground(
            .visible,
            for: .navigationBar
        )
    }
}


#Preview {
    NavigationStack{
        TopAlbumsView(
            topAlbumsViewModel: TopAlbumsViewModel(
                albumsRepository: AlbumsRepository(
                    albumsRepositoryDataProvider: AlbumsRepositoryDataProvider(.hardCoded)
                )
            )
        )
    }
}
