//
//  ContentView.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import SwiftUI

struct PostsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject private var vm: PostListViewModel
    
    @State private var selectedColor = "All"
    @State private var showingAlert = false
    @State private var showingAlertFavorite = false
    
    
    init(vm: PostListViewModel) {
        self.vm = vm
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        let postToList = selectedColor == "Favorites" ? vm.postsCahed.filter{ $0.star } : vm.postsCahed
        
        NavigationView {
            VStack {
                ZStack {
                    if (vm.postsCahed.isEmpty) {
                        VStack {
                            Image(systemName: SFSymbols.gearshape2fill).font(.system(size: 30)).foregroundColor(.gray)
                            Text("there aren't posts").font(.caption).padding(.top, 10)
                            Button {
                                vm.fetchPosts()
                            } label: {
                                Text("Do you want to download data from API ?").font(.caption2).foregroundColor(.blue).padding(.top, 5)
                            }
                        }
                    } else {
                        VStack {
                            Picker("choose a type section", selection: $selectedColor) {
                                ForEach(["All", "Favorites"], id: \.self) {
                                    Text($0)
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                            List {
                                ForEach(postToList) { post in
                                    NavigationLink {
                                        PostDetailView(post: post, vm: PostDetailViewModel(post: post, context: viewContext))
                                    } label: {
                                        HStack {
                                            if (post.star) {
                                                Image(systemName: SFSymbols.starFill).foregroundColor(.yellow)
                                            }
                                            Text(post.title)
                                                .font(.system(size: 14))
                                                .padding(.vertical, 10)
                                        }
                                    }.swipeActions(edge: .leading) {
                                        Button {
                                            vm.favoritePost(id: post.id)
                                        } label: {
                                            Label("Subtract ", systemImage: SFSymbols.star)
                                        }.tint(.yellow)
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            withAnimation {
                                                if (!post.star) {
                                                    vm.deletePost(id: post.id)
                                                }
                                            }
                                        } label: {
                                            Label("Subtract ", systemImage: "minus.circle")
                                        }
                                        .tint(.red)
                                        
                                    }
                                }
                            }.listStyle(.grouped)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    showingAlert = true
                }) {
                    Text("Delete all").foregroundColor(.red).padding(.top)
                }.alert("Do you want to delete all?", isPresented: $showingAlert) {
                    Button("Yes, delete all") { vm.deleteAllPosts() }
                    Button("Keep favorites") { vm.deleteAllPosts(keepFavorites: true) }
                    Button("Cancel", role: .cancel) { }
                }
                
            }
            .navigationTitle("Posts \(vm.postsCahed.count > 0 ? "(" + String(vm.postsCahed.count) + ")" : "" )")
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
