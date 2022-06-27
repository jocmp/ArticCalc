import XCTest
@testable import Arctic

final class LoanTests: XCTestCase {
    func testInit() throws {
        let loan = Loan(
            id: "mock-uuid-1",
            interestRate: 5,
            startingBalance: 150.00,
            minimumPayment: 20.00,
            currencyCode: "USD"
        )
        XCTAssertNotNil(loan)
    }
}
