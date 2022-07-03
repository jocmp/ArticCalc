//
//  ProjectionTests.swift
//  
//
//  Created by jocmp on 6/26/22.
//

import Foundation
import XCTest
@testable import Arctic

final class PaymentPlanTests: XCTestCase {
    func testSingleLoan() throws {
        let loan = Loan(
            id: "mock-uuid-1",
            interestRate: 5,
            startingBalance: 50,
            minimumPayment: 20.00,
            currencyCode: "USD"
        )
        
        let paymentPlan = PaymentPlan.calculate(
            loans: [loan],
            monthlyPaymentAmount: 20.00
        )
        
        let sheet = paymentPlan.findBalanceSheet(id: loan.id)
        
        let firstRow = sheet.rows.first!
        XCTAssertEqual(firstRow.paymentAmount, Decimal(20.00))
        XCTAssertEqual(firstRow.totalInterestPaid, Decimal(0.21))
        XCTAssertEqual(firstRow.principalBalance, Decimal(30.21))

        let lastRow = sheet.rows.last!
        XCTAssertEqual(lastRow.paymentAmount, Decimal(10.38))
        XCTAssertEqual(lastRow.totalInterestPaid, Decimal(0.38))
        XCTAssertEqual(lastRow.principalBalance, Decimal(0))
    }
    
    func testExtraPayments() throws {
        let loan = Loan(
            id: "mock-uuid-1",
            interestRate: 5,
            startingBalance: 150.00,
            minimumPayment: 20.00,
            currencyCode: "USD"
        )

        let paymentPlan = PaymentPlan.calculate(
            loans: [loan],
            monthlyPaymentAmount: 50.00
        )

        let sheet = paymentPlan.findBalanceSheet(id: loan.id)
        
        let firstRow = sheet.rows.first!
        XCTAssertEqual(firstRow.paymentAmount, Decimal(50.00))
        XCTAssertEqual(firstRow.totalInterestPaid, Decimal(0.62))
        XCTAssertEqual(firstRow.principalBalance, Decimal(100.62))

        let lastRow = sheet.rows.last!
        XCTAssertEqual(lastRow.paymentAmount, Decimal(1.26))
        XCTAssertEqual(lastRow.totalInterestPaid, Decimal(1.26))
        XCTAssertEqual(lastRow.principalBalance, Decimal(0))
    }
    
    func testMultipleLoansWithAvalancheStrategy() throws {
        let highInterestLoan = Loan(
            id: "mock-uuid-1",
            name: "High Interest Loan",
            interestRate: 12,
            startingBalance: 500.00,
            minimumPayment: 10.00,
            currencyCode: "USD"
        )

        let lowInterestLoan = Loan(
            id: "mock-uuid-2",
            name: "Low Interest Loan",
            interestRate: 5,
            startingBalance: 300.00,
            minimumPayment: 20.00,
            currencyCode: "USD"
        )
                
        let lowInterestLowBalanceLoan = Loan(
            id: "mock-uuid-3",
            name: "Low Interest Loan with Lower Balance",
            interestRate: 5,
            startingBalance: 150.00,
            minimumPayment: 20.00,
            currencyCode: "USD"
        )

        let loans = [highInterestLoan, lowInterestLoan, lowInterestLowBalanceLoan]
        let paymentPlan = PaymentPlan.calculate(
            loans: loans,
            monthlyPaymentAmount: 50.00
        )
        
        XCTAssertEqual(paymentPlan.principalPaidAmount, Decimal(950.00))
        XCTAssertEqual(paymentPlan.interestPaidAmount, Decimal(87.27))
    }
    
    func testMultipleLoansWithSnowballStrategy() throws {
        let highInterestLoan = Loan(
            id: "mock-uuid-1",
            name: "High Interest Loan",
            interestRate: 12,
            startingBalance: 500.00,
            minimumPayment: 10.00,
            currencyCode: "USD"
        )

        let lowInterestLoan = Loan(
            id: "mock-uuid-2",
            name: "Low Interest Loan",
            interestRate: 5,
            startingBalance: 300.00,
            minimumPayment: 20.00,
            currencyCode: "USD"
        )
                
        let lowInterestLowBalanceLoan = Loan(
            id: "mock-uuid-3",
            name: "Low Interest Loan with Lower Balance",
            interestRate: 5,
            startingBalance: 150.00,
            minimumPayment: 20.00,
            currencyCode: "USD"
        )

        let loans = [highInterestLoan, lowInterestLoan, lowInterestLowBalanceLoan]
        let paymentPlan = PaymentPlan.calculate(
            loans: loans,
            monthlyPaymentAmount: 50.00,
            strategy: .Snowball
        )

        XCTAssertEqual(paymentPlan.principalPaidAmount, Decimal(950.0))
        // Snowball will result in a higher overall interest payment than 
        XCTAssertEqual(paymentPlan.interestPaidAmount, Decimal(89.25))
    }
}
