//
//  AlbumCellView.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import SwiftUI

struct AlbumCellView: View {
    
    // Note: No need for viewModel since there are no edit events to handle
    let album: Album
    
    var body: some View {
        VStack(alignment: .leading) {

            CachedAsyncImage(url: album.artworkUrl) { result in
                result.image?.resizable()
            }
            .scaledToFit()
                    
            VStack(alignment: .leading) {
                Text(album.name)
                    .font(.headline)
                    .foregroundStyle(Color("CellFont"))
                
                Text(album.artistName)
                    .foregroundStyle(Color("CellFont"))
            }
            .padding(10)
            

        }
        .background(Color("CellBackground"))
        .cornerRadius(20)
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

