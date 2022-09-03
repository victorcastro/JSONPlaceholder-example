//
//  ApiManager.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import Foundation
import Combine

class ServiceManager {
    
    private var subscriber = Set<AnyCancellable>()
    
    func callService<T: Decodable>(method: ApiMethod, path: ApiPath, completion: @escaping (Result<T, Error>) -> Void )  {
        
        guard let url = URL(string: ApiContants.url + path.rawValue) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { (resultCompletion) in
                switch resultCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    return
                }
            } receiveValue: { (res) in
                completion(.success(res))
            }
            .store(in: &subscriber)
    }
    
}
