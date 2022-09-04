//
//  ServiceManager.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import Foundation

class ApiManager {
    
    private let service = ServiceManager()
    
    func getPost(id: String, completion: @escaping (Result<Post, Error>) -> Void) {
        service.callService(method: .get, path: .post, pathId: id) { (result: Result<Post, Error>) in
            switch result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        service.callService(method: .get, path: .posts) { (result: Result<[Post], Error>) in
            switch result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


extension String
{
    func replace(_ target: String, withThis: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withThis, options: NSString.CompareOptions.literal, range: nil)
    }
}
