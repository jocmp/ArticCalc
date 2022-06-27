import Foundation
import Money

public typealias LoanID = String

public struct Loan: Identifiable {
    public let id: LoanID
    public let name: String
    public let createdAt: Date
    public let interestRate: Decimal
    public let startingBalance: AnyMoney
    public let minimumPayment: AnyMoney

    public init(
        id: String,
        name: String = "",
        interestRate: Decimal,
        startingBalance: Decimal,
        minimumPayment: Decimal,
        createdAt: Date = Date.init(),
        currencyCode: String = "USD"
    ) {
        self.id = id
        self.name = name
        self.interestRate = interestRate
        self.startingBalance = Monetize.from(startingBalance, currencyCode: currencyCode)!
        self.minimumPayment = Monetize.from(minimumPayment, currencyCode: currencyCode)!
        self.createdAt = createdAt
    }
}
