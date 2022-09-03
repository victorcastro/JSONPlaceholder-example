//
//  PostListModelView.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import Foundation
import Combine

class PostListViewModel: ObservableObject {
    
    @Published var posts = [PostViewModel]()
    private let apiManager = ApiManager()
    
    func fetchPosts() {
        apiManager.getPosts { (result: Result<[Post], Error>) in
            switch result {
            case .success(let res):
                self.posts = res.map{ PostViewModel($0) }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

struct PostViewModel: Identifiable {
    let id = UUID()
    private let post: Post
    
    var idPost: Int {
        return post.id
    }
    
    var star: Bool {
        return Bool.random()
    }
    
    var title: String {
        return post.title
    }
    
    var description: String {
        return post.body
    }
    
    init(_ post: Post) {
        self.post = post
    }
}
