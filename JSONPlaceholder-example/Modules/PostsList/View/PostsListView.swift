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
    
    @StateObject var postListVM = PostListViewModel()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    
    var body: some View {
        NavigationView {
            ZStack {
                if (postListVM.posts.isEmpty) {
                    ProgressView()
                } else {
                    VStack {
                        List {
                            ForEach(postListVM.posts, id: \.id) { post in
                                NavigationLink {
                                    PostDetailView(id: post.idPost)
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
                            .onDelete(perform: deletePost)
                        }.listStyle(.grouped)
                        
                        Button(action: {
                            deleteAllPosts()
                        }) {
                            Text("Delete all").foregroundColor(.red).padding(.top)
                        }
                        
                    }.padding()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button(action: {
                                    postListVM.fetchPosts()
                                }) {
                                    Label("Download", systemImage: SFSymbols.icloudDown)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
                        }
                }
            }.navigationTitle("Posts")
                .navigationBarTitleDisplayMode(.automatic)
        }
        .onAppear{
            postListVM.fetchPosts()
        }
    }
    
    
    private func addPost() {
        withAnimation {
            let post = Item(context: viewContext)
            post.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deletePost(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteAllPosts() {
        withAnimation {
            items.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}
