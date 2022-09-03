//
//  PostModel.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import Foundation

struct Post: Decodable {
    var id: Int
    var userId: Int
    var title: String
    var body: String
}
