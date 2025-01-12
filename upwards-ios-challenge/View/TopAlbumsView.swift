//
//  TopAlbumsView.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import SwiftUI

struct TopAlbumsView: View {
    
    @StateObject var topAlbumsViewModel = TopAlbumsViewModel()
    
    // This records which albums have been displayed so that the album appearance animation
    // only plays once per album
    @State private var albumsAppeared: Set<Album> = []
    @State var sortPopOverIsPresented = false
    @State var loadingAnimationBegun = false
    
    // Make a 2-column grid
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        mainView
        .background(Color("Background"))
        .navBarStyling(title: "Top Albums")
        .toolbar {
            HStack {
                navBarSortButton
            }
        }
    }
    
    
    
    var navBarSortButton : some View {
        // NOTE: I'd rather use a picker but a Menu is much easier to style
        VStack {
            Menu {
                Text("Sort by...")
                ForEach(AlbumSortOrder.allCases, id:\.self) { sortOrder in
                    Button(action: {
                        topAlbumsViewModel.menuTapped(albumSortOrder: sortOrder)
                    }) {
                        Text(sortOrder.description)
                    }
                    
                }
            } label: {
                Image(systemName: "text.alignleft")
                    .resizable()
                    .padding(6)
                    .frame(width: 30, height: 30)
            }.menuStyle(.borderlessButton)
        }
    }
    
    @ViewBuilder
    var mainView: some View {
        if let errorMessage = topAlbumsViewModel.errorMessage {
            VStack {
                Text("Network Error")
                    .font(.largeTitle)
                Button("Try Again") {
                    topAlbumsViewModel.btnTryAgainTapped()
                }
                ScrollView {
                    Text("Error message: \(errorMessage)")
                        .font(.footnote)
                        .padding(20)
                }
                .frame(maxHeight: 300)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if topAlbumsViewModel.albums.count > 0 {
            ScrollView() {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), alignment: .top),
                        GridItem(.flexible(), alignment: .top)
                    ],
                    alignment: .leading,
                    spacing: 10
                ) {
                    ForEach(topAlbumsViewModel.albums, id: \.self) { album in
                        NavigationLink(
                            destination: AlbumDetailView(album: album)
                        ) {
                            makeCell(album: album)
                        }
                    }
                }
                // Add a search bar to the nav bar
                .searchable(
                    text: $topAlbumsViewModel.searchString
                )
                .padding(10)
            }
        } else {
            ProgressView() {
                Text("Loading...")
                    .foregroundStyle(Color("CellFont"))
                
                    // Have the text rotate like a see-saw
                    .rotationEffect(.degrees(loadingAnimationBegun ? -35 : 35))
                    .animation(
                        // Animate for 1 second, reverse, and repeat
                        .easeInOut(
                            duration: 1
                        )
                        .repeatForever(
                            autoreverses: true
                        ),
                        value: loadingAnimationBegun
                    )
                    .onAppear {
                        loadingAnimationBegun = true
                    }
            }
            .progressViewStyle(.circular)
            .tint(.white)
            .scaleEffect(3.0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    func makeCell(album: Album) -> some View {
        AlbumCellView(album: album)
            // When cells appear, scale them up and fade them in
            .opacity(albumsAppeared.contains(album) ? 1 : 0)
            .scaleEffect(albumsAppeared.contains(album) ? 1 : 0.2)
            .rotation3DEffect(
                Angle(degrees: albumsAppeared.contains(album) ? 0 : 180),
                axis: (x: 0, y: 1, z: 0)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5)) {
                    _ = albumsAppeared.insert(album)
                }
            }
    }
    
    
    
}


#Preview {
    NavigationStack{
        TopAlbumsView(
            topAlbumsViewModel: TopAlbumsViewModel(
                albumsRepository: AlbumsRepository(
                    albumsRepositoryDataProvider: AlbumsRepositoryDataProvider(.alwaysFail)
                )
            )
        )
    }
}
