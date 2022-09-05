//
//  PostListModelView.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import Foundation
import CoreData

@MainActor
class PostListViewModel: NSObject, ObservableObject {
    
    var posts = [Post]()
    @Published var postsCahed = [PostCacheViewModel]()
    
    private let apiManager = ApiManager()
    
    private (set) var context: NSManagedObjectContext
    
    private let fetchedResultsController: NSFetchedResultsController<CDPosts>
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: CDPosts.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        self.fetchedResultsController.delegate = self
        getPostFromPersistence()
    }
    
    // MARK: - Handling data
    
    func getPostsFromService() {
        apiManager.getPosts { (result: Result<[Post], Error>) in
            switch result {
            case .success(let res):
                self.posts = res
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func getPostFromPersistence() {
        do {
            try fetchedResultsController.performFetch()
            guard let corePosts = fetchedResultsController.fetchedObjects else { return }
            self.postsCahed = corePosts.map{ PostCacheViewModel(post: $0) }
        } catch {
            print(error)
        }
    }
    
    func fetchPosts() {
        deleteAllPosts()
        apiManager.getPosts { (result: Result<[Post], Error>) in
            switch result {
            case .success(let res):
                if res.count > 0 {
                    for post in res {
                        let p = CDPosts(context: self.context)
                        p.idPost = Int64(post.id)
                        p.idUser = Int64(post.userId)
                        p.title = post.title
                        p.desc = post.body
                        do {
                            try p.save()
                        } catch let error as NSError {
                            fatalError("Unresolved error \(error), \(error.userInfo)")
                        }
                        
                    }
                }
                
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
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func deletePost(id: NSManagedObjectID) {
        do {
            guard let post = try context.existingObject(with: id) as? CDPosts else { return }
            try post.delete()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllPosts() {
        guard let corePosts = fetchedResultsController.fetchedObjects else { return }
        for post in corePosts {
            context.delete(post)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

extension PostListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let corePosts = controller.fetchedObjects as? [CDPosts] else { return }
        self.postsCahed = corePosts.map{ PostCacheViewModel(post: $0) }
    }
}

struct PostCacheViewModel: Identifiable {
    
    private let post: CDPosts
    
    init(post: CDPosts) {
        self.post = post
    }
    
    var id: NSManagedObjectID {
        post.objectID
    }
    
    var idPost: Int {
        Int(post.idPost)
    }
    
    var idUser: Int {
        Int(post.idUser)
    }
    
    var star: Bool {
        post.star
    }
    
    var title: String {
        post.title ?? ""
    }
    
    var description: String {
        post.desc ?? ""
    }
    
}
