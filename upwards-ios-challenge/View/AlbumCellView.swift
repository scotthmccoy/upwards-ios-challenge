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
            Image("DarkSideOfTheMoon")
                .resizable()
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
    VStack {
//        AlbumCellView(
//            album: Album(
//                id: "123",
//                name: "Dark Side of the Moon",
//                artistName: "Pink Floyd",
//                releaseDate: Date()
//            )
//        )
//        .containerRelativeFrame([.horizontal, .vertical]) { length, axis in
//            if axis == .horizontal {
//                return length * 0.4
//            }
//            
//            if axis == .vertical {
//                return length * 1
//            }
//            
//            return 0
//        }
  
         ScrollView() {
             LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 10
             ) {
                 ForEach(1...10, id: \.self) { item in
                     Rectangle()
                         .fill(.purple)
                         .aspectRatio(3.0 / 2.0, contentMode: .fit)
//                         .containerRelativeFrame(
//                            .horizontal,
//                             count: 7,
//                             span: 2,
//                             spacing: 0
//                         )
                         .border(.red)
                 }
             }
         }
         .safeAreaPadding(.horizontal, 20.0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("Background"))
}
