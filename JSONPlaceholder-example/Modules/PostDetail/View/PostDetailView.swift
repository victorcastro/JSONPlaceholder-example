//
//  PostDetailView.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import SwiftUI

struct PostDetailView: View {
    let id: Int
    
    @State var isFavorite = false
    
    var body: some View {
        VStack {
            Text("Description").font(.title2)
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    tapFavorite()
                }) {
                    Label("Star", systemImage: isFavorite ? SFSymbols.starFill : SFSymbols.star)
                        .foregroundColor(.yellow)
                }
            }
        }.navigationTitle("Post")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func tapFavorite() {
        isFavorite.toggle()
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(id: 0)
    }
}
