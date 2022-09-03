//
//  GloblaContants.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import Foundation

struct ApiContants {
    static let url = "https://jsonplaceholder.typicode.com"
}

enum ApiMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ApiPath: String {
    case posts = "/posts"
}
