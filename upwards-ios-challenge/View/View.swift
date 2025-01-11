//
//  View.swift
//  upwards-ios-challenge
//
//  Created by Scott McCoy on 1/10/25.
//

import SwiftUI

extension View {
    nonisolated public func navBarStyling(title: String) -> some View {
        
        self
        
        .navigationBarTitle(title, displayMode: .inline)
        
        // Nav Bar Text Color
        .toolbarColorScheme(.dark, for: .navigationBar)
        
        // Nav Bar Background color
        .toolbarBackground(
            .visible,
            for: .automatic
        )
        
        .toolbarBackground(
            Color("NavBar"),
            for: .automatic
        )

    }
}
