//
//  AlbumDetailView.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/9/25.
//

import SwiftUI

struct AlbumDetailView: View {
    
    // Note: No need for viewModel since there are no edit events to handle
    let album: Album
    
    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: album.artworkUrl) { phase in
                switch phase {
                    case .success(let image):
                        image.resizable()
                    default:
                        Image("Loading")
                            .resizable()
                }
            }
            .scaledToFill()
                    
            ScrollView {
                VStack(alignment: .leading) {
                    Text(album.name)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color("CellFont"))
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    
                    Text(album.artistName)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color("CellFont"))
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)
                    
                    Text("Social Media")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color("CellFont"))
                        .font(.headline)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color("CellFont"))
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)
                    
                    Text("News")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color("CellFont"))
                        .font(.headline)
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color("CellFont"))
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)
                }
            }
        }
        .background(Color("CellBackground"))
        .navBarStyling(title: "")
    }
    
}

//#Preview {
//    AlbumDetailView(album:
//        Album(
//            id: "1",
//            name: "Album Name",
//            artworkUrl: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music221/v4/a0/e3/e0/a0e3e0d3-f6c8-8a1c-bcf1-17c49154b986/24UM1IM08555.rgb.jpg/100x100bb.jpg")!,
//            artistName: "Artist Name",
//            releaseDate: Date(),
//            genres: ["Hip-Hop"]
//        )
//    )
//}


#Preview {
    NavigationStack{
        TopAlbumsView(
            topAlbumsViewModel: TopAlbumsViewModel(
                albumsRepository: AlbumsRepository(
                    albumsRepositoryDataProvider: AlbumsRepositoryDataProvider(.mainBundleTestData)
                )
            )
        )
    }
}
