//
//  ArticLoan+CoreData.swift
//  ArticApp
//
//  Created by jocmp on 6/19/22.
//

import Foundation
import Artic
import Money

extension PresentedLoan {
    static func from(loan: Loan?) -> PresentedLoan {
        return .init(loan: fromArticLoan(loan: loan))
    }
}

fileprivate func fromArticLoan(loan: Loan?) -> Artic.Loan {
    guard let safeLoan = loan else {
         return .init(id: withID())
    }

    return .init(
        id: withID(id: safeLoan.id),
        name: safeLoan.name ?? "",
        interestRate: safeLoan.interestRate,
        currentAmountCents: Int(safeLoan.currentAmountCents),
        minimumPaymentCents: Int(safeLoan.minimumPaymentCents)
    )
}

fileprivate func withID(id: UUID? = nil) -> String {
    guard let safeID = id else {
        return UUID().uuidString
    }
    
    return safeID.uuidString
}
