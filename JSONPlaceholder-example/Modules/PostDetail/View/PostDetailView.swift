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
        VStack(alignment: .leading) {
            Text("Description").font(.title2).padding(.bottom, 5)
            Text(post.description).font(.callout).padding(.bottom)
            
            Text("User").font(.title2).padding(.bottom, 5)
            VStack(alignment: .leading) {
                Text("Name: " + (vm.author?.name ?? ""))
                Text("Email: " + (vm.author?.email ?? ""))
                Text("Phone: " + (vm.author?.phone ?? ""))
                Text("Website: " + (vm.author?.website ?? ""))
            }.padding(.bottom)
            
            Text("Comments").font(.title2).padding(.bottom, 5)
            List {
                ForEach(vm.comments, id: \.id) { comment in
                    VStack(alignment: .leading) {
                        Text(comment.name).font(.callout)
                        Text(comment.body).font(.caption2)
                    }.padding(.vertical)
                }.listRowInsets(EdgeInsets())
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    tapFavorite()
                }) {
                    Label("Star", systemImage: post.star ? SFSymbols.starFill : SFSymbols.star)
                        .foregroundColor(.yellow)
                }
            }
        }.navigationTitle("Post")
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                vm.getComments(id: post.idPost)
                vm.getAuthor(id: post.idUser)
            }
    }
    
    private func tapFavorite() {
        isFavorite.toggle()
        vm.favoritePost(id: post.id)
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
