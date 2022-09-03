//
//  PostDetailView.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import SwiftUI

struct PostDetailView: View {
    let id: Int
    
    @StateObject var postDetailVM = PostDetailViewModel()
    
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
            .onAppear{
                postDetailVM.getPost(id: 1)
            }
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
