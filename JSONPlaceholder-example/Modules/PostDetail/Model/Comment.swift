//
//  Comment.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import Foundation

struct Comment: Decodable {
    var id: Int
    var postId: Int
    var name: String
    var email: String
    var body: String
}
