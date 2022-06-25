//
//  PresentedLoan.swift
//  ArticApp
//
//  Created by jocmp on 6/20/22.
//

import Foundation
import Artic

struct PresentedLoan: Identifiable {
    let loan: Artic.Loan
    
    init(loan: Artic.Loan) {
        self.loan = loan
    }

    var id: String {
        loan.id
    }

    var name: String {
        loan.name
    }

    var currentAmount: String {
        loan.currentAmount.localized()
    }

    var minimumAmount: String {
        loan.minimumPayment.localized()
    }

    var interestRate: String {
        loan.interestRate.formatted()
    }
}

fileprivate extension AnyMoney {
    func localized() -> String {
        MoneyParser.format(amount as NSNumber, localeCode: Locale.current.identifier, currencyCode: currency.code)
    }
}
