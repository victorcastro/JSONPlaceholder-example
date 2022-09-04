//
//  JSONPlaceholder_exampleApp.swift
//  JSONPlaceholder-example
//
//  Created by Victor Castro on 2/09/22.
//

import SwiftUI

@main
struct JSONPlaceholder_exampleApp: App {
    

    var body: some Scene {
        WindowGroup {
            let viewContext = CoreDataManager.shared.container.viewContext
            PostsListView(vm: PostListViewModel(context: viewContext))
                .environment(\.managedObjectContext, viewContext)
        }
    }
}
