import Foundation
import Money

public struct Loan: Identifiable {
    public let id: String
    public let name: String
    public let createdAt: Date
    public let interestRate: Double
    public let currentAmount: AnyMoney
    public let minimumPayment: AnyMoney

    public init(
        id: String,
        name: String = "",
        interestRate: Double = 0,
        currentAmountCents: Int = 0,
        minimumPaymentCents: Int = 0,
        createdAt: Date = Date.init(),
        currencyCode: String = "USD"
    ) {
        self.id = id
        self.name = name
        self.interestRate = interestRate
        self.currentAmount = Monetize.from(minorUnits: currentAmountCents, currencyCode: currencyCode)!
        self.minimumPayment = Monetize.from(minorUnits: currentAmountCents, currencyCode: currencyCode)!
        self.createdAt = createdAt
    }
}
