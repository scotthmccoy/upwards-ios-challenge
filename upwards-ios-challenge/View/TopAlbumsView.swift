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
                        AlbumCellView(album: album)
                    }
                }
            }
            .padding(10)
        }
        .background(Color("Background"))
        .navigationBarBackground()
        .navigationBarTitle("Top Albums", displayMode: .inline)
//        
//        // Nav Bar Text Color
//        .toolbarColorScheme(.dark, for: .navigationBar)
//        
//        // Nav Bar Background color
//        .toolbarBackground(
//            .visible,
//            for: .automatic
//        )
//        
//        .toolbarBackground(
//            Color("NavBar"),
//            for: .automatic
//        )

        .toolbar {
            HStack {
                btnSort
            }
        }
    }
    
    @State var sortPopOverIsPresented = false
    var btnSort : some View {
        // NOTE: I'd rather use a picker but this is much easier to style
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

    }}


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
