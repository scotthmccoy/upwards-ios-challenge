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
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(topAlbumsViewModel.albums, id: \.self) { album in
                    AlbumCellView(album: album)
                }
            }
            .background(Color("Background"))
        }
        .navigationBarTitle("Top Albums", displayMode: .inline)
        .toolbarBackground(Color("NavBar"))
    }
}


#Preview {
    TopAlbumsView(
        topAlbumsViewModel: TopAlbumsViewModel(
            albumsRepository: AlbumsRepository(
                albumsRepositoryDataProvider: AlbumsRepositoryDataProvider(.hardCoded)
            )
        )
    )
}
