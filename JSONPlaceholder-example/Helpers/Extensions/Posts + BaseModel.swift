//
//  PostsEntity + BaseModel.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 3/09/22.
//

import Foundation
import CoreData

extension CDPosts: BaseModel {
    static var viewContext: NSManagedObjectContext {
        CoreDataManager.shared.container.viewContext
    }
    
    static var all: NSFetchRequest<CDPosts> {
        let request = CDPosts.fetchRequest()
        request.sortDescriptors = []
        return request
    }
}
