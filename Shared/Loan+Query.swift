//
//  Loan+Query.swift
//  ArcticApp
//
//  Created by jocmp on 7/3/22.
//

import Foundation
import CoreData

extension Loan {
    static func findByID(id: String) -> NSFetchRequest<Loan> {
      let request = Loan.fetchRequest()
      request.predicate = NSPredicate(format: "id = %@", id)
      request.sortDescriptors = []
      request.fetchLimit = 1
      return request
    }
    
    static func findByName(name: String) -> NSFetchRequest<Loan> {
        let request = Loan.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        request.sortDescriptors = []
        request.fetchLimit = 1
        return request
    }
    
    static func findAll() -> NSFetchRequest<Loan> {
      let request = Loan.fetchRequest()
      request.sortDescriptors = []
      return request
    }
}
