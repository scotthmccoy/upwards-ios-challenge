//
//  TopAlbumsView.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import SwiftUI

struct TopAlbumsView: View {
    
    @StateObject var topAlbumsViewModel = TopAlbumsViewModel()
    
    var body: some View {
        ForEach(topAlbumsViewModel.albums, id: \.self) { album in
            Text("album: \(album.name)")
            
        }
        //.background(Color("CellBackground"))
        //.background(Color("NavBar"))
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
