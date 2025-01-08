//
//  TopAlbumsView.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/7/25.
//

import SwiftUI

struct TopAlbumsView: View {
    
    @StateObject private var topAlbumsViewModel = TopAlbumsViewModel()
    
    var body: some View {
        ForEach(topAlbumsViewModel.albums, id: \.self) { album in
            Text("album: \(album.name)")
        }
    }
}
