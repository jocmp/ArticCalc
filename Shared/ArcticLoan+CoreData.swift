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
    static func from(loan: Loan) -> PresentedLoan {
        return .init(loan: loan.asArcticLoan())
    }
}

extension Loan {
    func asArcticLoan() -> Arctic.Loan {
        return .init(
            id: withID(id: id),
            name: name ?? "",
            interestRate: interestRate!.decimalValue,
            startingBalance: startingBalance!.decimalValue,
            minimumPayment: minimumPayment!.decimalValue
        )
    }
}

fileprivate func withID(id: UUID? = nil) -> String {
    guard let safeID = id else {
        return UUID().uuidString
    }

    return safeID.uuidString
}
