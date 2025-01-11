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
    
    @State private var newTagVisible = false // Controls opacity
    
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
            .scaledToFit()
            .overlay {
                makeNewTag()
            }
            .transition(.opacity)
                    
            VStack(alignment: .leading) {
                Text(album.name)
                    .font(.headline)
                    .foregroundStyle(Color("CellFont"))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(album.artistName)
                    .foregroundStyle(Color("CellFont"))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .padding(10)
            
            Spacer()
        }
        .frame(minHeight: 300)
        .background(Color("CellBackground"))
        .cornerRadius(20)
    }
    
    @ViewBuilder func makeNewTag() -> some View {
        if album.isNew() {
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
                }
                Spacer()
            }
            .opacity(newTagVisible ? 1 : 0) // Start hidden
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5)) {
                    newTagVisible = true // Fade in
                }
            }
        }
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

