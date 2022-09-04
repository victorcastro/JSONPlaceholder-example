//
//  PostDetailView.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import SwiftUI
import CoreData

struct PostDetailView: View {
    let post: PostCacheViewModel
    
    @ObservedObject private var vm: PostDetailViewModel
    
    @State var isFavorite = false
    
    init(post: PostCacheViewModel, vm: PostDetailViewModel) {
        self.post = post
        self.vm = vm
    }
    
    var body: some View {
        VStack {
            Text("Description").font(.title2)
            Text(post.description)
            Text("User")
            Text("Comments")
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
                vm.getPost(id: post.idPost)
            }
    }
    
    private func tapFavorite() {
        isFavorite.toggle()
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = CoreDataManager.shared.container.viewContext
        
        let p = CDPosts(context: viewContext)
        let postCached = PostCacheViewModel(post: p)
        
        PostDetailView(post: postCached, vm: PostDetailViewModel(context: viewContext))
    }
}
