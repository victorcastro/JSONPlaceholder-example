//
//  PostDetailViewModel.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import Foundation
import CoreData

@MainActor
class PostDetailViewModel: NSObject, ObservableObject {
    
    private (set) var context: NSManagedObjectContext
    
    private let apiManager = ApiManager()
    
    let post: PostCacheViewModel
    
    @Published var comments: [Comment] = []
    @Published var author: Author?
        
    init(post: PostCacheViewModel , context: NSManagedObjectContext) {
        self.context = context
        self.post = post
        super.init()
        getAuthor(id: post.idUser)
        getComments(id: post.idPost)
    }
    
    func getComments(id: Int) {
        apiManager.getCommentsOfPost(id: String(id)) { (result: Result<[Comment], Error>) in
            switch result {
            case .success(let res):
                self.comments = res
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getAuthor(id: Int) {
        apiManager.getAuthor(id: String(id)) { (result: Result<Author, Error>) in
            switch result {
            case .success(let res):
                print(res)
                self.author = res
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions to CoreData
    
    func favoritePost(id: NSManagedObjectID) {
        do {
            guard let post = try context.existingObject(with: id) as? CDPosts else { return }
            post.star = !post.star
            try post.save()
            getComments(id: Int(post.idPost))
            getAuthor(id: Int(post.idUser))
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

