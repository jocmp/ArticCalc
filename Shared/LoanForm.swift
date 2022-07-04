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
    @Published var startingBalance = ""
    @Published var interestRate = ""
    @Published var minimumPayment: String = ""
    @Published var name = ""
    @Published var errors: [Error] = []

    func create(viewContext: NSManagedObjectContext) -> Bool {
        if !validate(viewContext) {
            return false
        }

        let loan = Loan(context: viewContext)
        loan.createdAt = Date()
        loan.id = UUID()
        loan.name = name
        loan.startingBalance = parseMoneyToDecimal(startingBalance)
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

    func validate(_ viewContext: NSManagedObjectContext) -> Bool {
        errors.removeAll()

        validateName(name, viewContext)
        validateMoneyFormat(minimumPayment, name: "minimumPayment")
        validateMoneyFormat(startingBalance, name: "startingBalance")
        validateDoubleFormat(interestRate, name: "interestRate")

        return isValid
    }

    var isValid: Bool {
        errors.isEmpty
    }
    
    func validateMoneyFormat(_ value: String, name: String) {
        if MoneyParser.parse(value) == nil {
            errors.append(Error(attribute: name, type: .MoneyFormat))
        }
    }
    
    func validateDoubleFormat(_ value: String, name: String) {
        if Double(value) == nil {
            errors.append(Error(attribute: name, type: .DoubleFormat))
        }
    }
    
    func validateName(_ value: String, _ viewContext: NSManagedObjectContext) {
        if value.isEmpty {
            errors.append(Error(attribute: "name", type: .Presence))
        }
        
        if isNameTaken(value, viewContext) {
            errors.append(Error(attribute: "name", type: .Uniqueness))
        }
    }

    func isNameTaken(_ value: String, _ viewContext: NSManagedObjectContext) -> Bool {
        do {
            return !(try viewContext.fetch(Loan.findByName(name: value)).isEmpty)
        } catch {
            return true
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
