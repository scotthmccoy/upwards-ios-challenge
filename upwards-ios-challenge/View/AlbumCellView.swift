//
//  AlbumCellView.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import SwiftUI

struct AlbumCellView: View {
    
    // Note: No need for viewModel since there are no edit events to handle
    @StateObject var albumCellViewModel: AlbumCellViewModel
    
    // This bool is faded from false to true to control animation of the "NEW" tag
    @State private var newTagAnimationComplete = false
    
    init(album: Album) {
        // Set the StateObject
        _albumCellViewModel = StateObject(
            wrappedValue: AlbumCellViewModel(
                album: album
            )
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: albumCellViewModel.album.artworkUrl) { phase in
                switch phase {
                    case .success(let image):
                        image.resizable()
                    default:
                        Image("Loading")
                            .resizable()
                }
            }
            .scaledToFit()
            .overlay {
                makeNewTag()
            }
            .transition(.opacity)
                    
            VStack(alignment: .leading) {
                Text(albumCellViewModel.album.title)
                    .font(.headline)
                    .foregroundStyle(Color("CellFont"))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(albumCellViewModel.album.artistName)
                    .font(.subheadline)
                    .foregroundStyle(Color("CellFont"))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(albumCellViewModel.genres)
                    .font(.footnote)
                    .foregroundStyle(Color("CellFont"))
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
            }
            .padding(10)
            
            Spacer()
        }
        .frame(minHeight: 300)
        .background(Color("CellBackground"))
        .cornerRadius(20)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("AlbumViewCell")
    }
    
    @ViewBuilder func makeNewTag() -> some View {
        if albumCellViewModel.isNew() {
            // MARK: "New" overlay
            VStack {
                HStack {
                    Spacer()
                    Text("NEW")
                        .font(.headline)
                        .foregroundStyle(Color("NewFont"))
                        .padding(3)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.white)
                        }
                        .padding()
                    
                        // When a New tag appears, it should spin, scale up and fade into view.
                        .opacity(newTagAnimationComplete ? 1 : 0) // Start hidden
                        .rotationEffect(.degrees(newTagAnimationComplete ? 0 : 180))
                        .scaleEffect(newTagAnimationComplete ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                newTagAnimationComplete = true
                            }
                        }
                        .accessibilityElement(children: .contain)
                        .accessibilityIdentifier("NewTag")

                }
                Spacer()
            }
        }
    }
}


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

