//
//  LoanForm.swift
//  Artic
//
//  Created by Josiah Campbell on 6/19/22.
//

import Foundation
import CoreData

class LoanForm: ObservableObject {
    @Published var currentAmountCents: Int = 0
    @Published var interestRate: Double = 0
    @Published var minimumPaymentCents = 0
    @Published var name = ""
    
    func create(viewContext: NSManagedObjectContext) {
        let loan = Loan(context: viewContext)
        loan.createdAt = Date()
        loan.id = UUID()
        loan.name = name
        loan.currentAmountCents = Int64(currentAmountCents)
        loan.interestRate = interestRate
        loan.minimumPaymentCents = Int64(minimumPaymentCents)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
