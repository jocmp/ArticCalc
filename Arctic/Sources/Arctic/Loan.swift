import Foundation
import Money

public struct Loan: Identifiable {
    public let id: String
    public let name: String
    public let createdAt: Date
    public let interestRate: Decimal
    public let startingBalance: AnyMoney
    public let minimumPayment: AnyMoney

    public init(
        id: String,
        name: String = "",
        interestRate: Decimal = 0,
        startingBalance: Decimal = 0,
        minimumPayment: Decimal = 0,
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
