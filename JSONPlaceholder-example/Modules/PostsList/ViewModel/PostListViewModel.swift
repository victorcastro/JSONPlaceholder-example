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
    
    @Published var posts = [PostViewModel]()
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
    
    func getPostsFromService() {
        apiManager.getPosts { (result: Result<[Post], Error>) in
            switch result {
            case .success(let res):
                self.posts = res.map{ PostViewModel(post: $0) }
                
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
        // TODO: Fetch all post from json to CorData
        getPostsFromService()
    }
    
    func addPost() {
        do {
            let post = CDPosts(context: context)
            post.idPost = 3
            post.idUser = 5
            post.title = "asdasdsd"
            try post.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
    
    init(post: Post) {
        self.post = post
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
