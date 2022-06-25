//
//  LoanForm.swift
//  Artic
//
//  Created by jocmp on 6/19/22.
//

import Foundation
import CoreData
import Money

class LoanForm: ObservableObject {
    @Published var currentAmount = ""
    @Published var interestRate = ""
    @Published var minimumPayment: String = ""
    @Published var name = ""
    @Published var errors: [Error] = []

    func create(viewContext: NSManagedObjectContext) -> Bool {
        if !validate() {
            return false
        }
        
        let loan = Loan(context: viewContext)
        loan.createdAt = Date()
        loan.id = UUID()
        loan.name = name
        loan.currentAmountCents = parseToCents(currentAmount)
        loan.interestRate = Double(interestRate)!
        loan.minimumPaymentCents = parseToCents(minimumPayment)
        loan.currencyCode = "USD"
        
        do {
            try viewContext.save()
            return true
        } catch {
            return false
        }
    }
    
    func validate() -> Bool {
        errors.removeAll()
        
        validate(name, name: "name", for: .Presence)
        validate(minimumPayment, name: "minimumPayment", for: .MoneyFormat)
        validate(currentAmount, name: "currentAmount", for: .MoneyFormat)
        validate(interestRate, name: "interestRate", for: .DoubleFormat)
        
        return isValid
    }

    var isValid: Bool {
        errors.isEmpty
    }
    
    func validate(_ value: String, name: String, for error: Error.ErrorType) {
        let isInvalid: Bool = {
            switch error {
            case .Presence:
                return value.isEmpty
            case .MoneyFormat, .DoubleFormat:
                return Double(value) == nil
            }
        }()

        if isInvalid {
            errors.append(Error(attribute: name, type: error))
        }
    }
    
    func parseToCents(_ value: String) -> Int64 {
        return Int64(exactly: Money<USD>.parse(value).cents())!
    }
}

extension Money {
    static func parse(_ value: String) -> Money {
        return .init(stringLiteral: value)
    }

    func cents() -> Int {
        let integerValue = (self.amount * pow(10, self.currency.minorUnit))
        return NSDecimalNumber(decimal: integerValue).intValue
    }
}
