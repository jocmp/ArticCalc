//
//  PresentedLoan.swift
//  ArcticApp
//
//  Created by jocmp on 6/20/22.
//

import Foundation
import Arctic

struct PresentedLoan: Identifiable {
    let percentFormatter = makePercentFormatter()
    let loan: Arctic.Loan

    init(loan: Arctic.Loan) {
        self.loan = loan
    }

    var id: String {
        loan.id
    }

    var name: String {
        loan.name
    }

    var startingBalance: String {
        loan.startingBalance.displayed()
    }

    var minimumAmount: String {
        loan.minimumPayment.displayed()
    }

    var interestRate: String {
        let rounded = (loan.interestRate / 100.0) as NSNumber
        return percentFormatter.string(from: rounded)!
    }
}

fileprivate func makePercentFormatter() -> NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
}

fileprivate extension AnyMoney {
    func displayed() -> String {
        MoneyParser.format(amount, localeCode: Locale.current.identifier, currencyCode: currency.code)
    }
}
