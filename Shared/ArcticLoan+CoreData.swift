//
//  ArcticLoan+CoreData.swift
//  ArcticApp
//
//  Created by jocmp on 6/19/22.
//

import Foundation
import Arctic
import Money

extension PresentedLoan {
    static func from(loan: Loan?) -> PresentedLoan {
        return .init(loan: fromArcticLoan(loan: loan))
    }
}

fileprivate func fromArcticLoan(loan: Loan?) -> Arctic.Loan {
    guard let safeLoan = loan else {
         return .init(id: withID())
    }

    return .init(
        id: withID(id: safeLoan.id),
        name: safeLoan.name ?? "",
        interestRate: safeLoan.interestRate!.decimalValue,
        startingBalance: safeLoan.startingBalance!.decimalValue,
        minimumPayment: safeLoan.minimumPayment!.decimalValue
    )
}

fileprivate func withID(id: UUID? = nil) -> String {
    guard let safeID = id else {
        return UUID().uuidString
    }

    return safeID.uuidString
}
