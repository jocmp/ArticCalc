//
//  LoanForm.swift
//  Arctic
//
//  Created by jocmp on 6/19/22.
//

import Foundation
import CoreData
import Money
import Arctic

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
        loan.currentAmount = parseMoneyToDecimal(currentAmount)
        loan.interestRate = NSDecimalNumber(string: interestRate)
        loan.minimumPayment = parseMoneyToDecimal(minimumPayment)
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
            case .MoneyFormat:
                return MoneyParser.parse(value) == nil
            case .DoubleFormat:
                return Double(value) == nil
            }
        }()

        if isInvalid {
            errors.append(Error(attribute: name, type: error))
        }
    }

    func parseMoneyToDecimal(_ value: String) -> NSDecimalNumber {
        let parsed = MoneyParser.parse(value)!
        return NSDecimalNumber(decimal: parsed)
    }
}

extension Money {
    func cents() -> Int {
        let integerValue = (self.amount * pow(10, self.currency.minorUnit))
        return NSDecimalNumber(decimal: integerValue).intValue
    }
}
