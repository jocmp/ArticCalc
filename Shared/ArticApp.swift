//
//  ArticApp.swift
//  Shared
//
//  Created by jocmp on 6/12/22.
//

import SwiftUI

@main
struct ArticApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoanList()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
