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
        Text(album.name)
            .font(.headline)
            .padding()
            .background(Color("CellBackground"))
            .cornerRadius(15)
    }
}
