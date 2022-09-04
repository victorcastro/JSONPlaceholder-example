//
//  ContentView.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import SwiftUI
import CoreData

struct PostsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject private var vm: PostListViewModel
    
    init(vm: PostListViewModel) {
        self.vm = vm
        UITableView.appearance().backgroundColor = .clear
    }
    
    private func deletePostIndex(at offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                let post = vm.postsCahed[index]
                if (!post.star) {
                    vm.deletePost(id: post.id)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    if (vm.postsCahed.isEmpty) {
                        VStack {
                            Image(systemName: SFSymbols.gearshape2fill).font(.system(size: 30)).foregroundColor(.gray)
                            Text("there aren't posts").font(.caption).padding(.top, 10)
                        }
                    } else {
                        List {
                            ForEach(vm.postsCahed) { post in
                                NavigationLink {
                                    PostDetailView(id: Int(post.idPost))
                                } label: {
                                    HStack {
                                        if (post.star) {
                                            Image(systemName: SFSymbols.starFill).foregroundColor(.yellow)
                                        }
                                        Text(post.title)
                                            .font(.system(size: 14))
                                            .padding(.vertical, 10)
                                    }
                                }
                            }
                            .onDelete(perform: deletePostIndex)
                            
                        }
                        .listStyle(.grouped)
                    }
                }
                Spacer()
                Button(action: {
                    vm.deleteAllPosts()
                }) {
                    Text("Delete all").foregroundColor(.red).padding(.top)
                }
                
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.automatic)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        vm.fetchPosts()
                    }) {
                        Label("Download", systemImage: SFSymbols.icloudDown)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { !vm.postsCahed.isEmpty ? EditButton() : nil }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = CoreDataManager.shared.container.viewContext
        PostsListView(vm: PostListViewModel(context: viewContext))
    }
}
