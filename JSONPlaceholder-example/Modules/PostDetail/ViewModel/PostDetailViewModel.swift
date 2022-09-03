//
//  PostDetailViewModel.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import Foundation
import Combine

class PostDetailViewModel: ObservableObject {
    
    // @Published var post = Post()
    
    private let apiManager = ApiManager()
    
    func getPost(id: Int) {
        apiManager.getPost(id: String(id)) { (result: Result<Post, Error>) in
            switch result {
            case .success(let res):
                // self.post = res
                print(res)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
