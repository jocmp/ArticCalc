//
//  PaymentPlan.swift
//  ArcticApp
//
//  Created by jocmp on 7/3/22.
//

import Foundation
import CoreData
import Arctic

class PresentedPaymentPlan: ObservableObject {
    private let loans: [Loan]
    private var paymentPlan: PaymentPlan
    var minimumPayment: Int
    @Published var monthlyPayment: Int {
        didSet {
            calculate()
        }
    }

    init(viewContext: NSManagedObjectContext) {
        self.loans = try! viewContext.fetch(Loan.findAll())
        let arcticLoans = loans.map { $0.asArcticLoan() }
        minimumPayment = (arcticLoans.reduce(0, { accumulator, loan in
            accumulator + loan.minimumPayment.amount
        }) as NSDecimalNumber).intValue
        paymentPlan = PaymentPlan.calculate(
            loans: arcticLoans,
            monthlyPaymentAmount: Decimal(minimumPayment)
        )
        monthlyPayment = minimumPayment
    }
    
    func calculate() {
        paymentPlan = PaymentPlan.calculate(
            loans: loans.map { $0.asArcticLoan()},
            monthlyPaymentAmount: Decimal(monthlyPayment)
        )
    }
    
    var interestPaid: String {
        return paymentPlan.interestPaidAmount.formatted()
    }
    
    var principalPaid: String {
        return paymentPlan.principalPaidAmount.formatted()
    }
}
