//
//  ServiceManager.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import Foundation

class ApiManager {
    
    private let service = ServiceManager()
    
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
