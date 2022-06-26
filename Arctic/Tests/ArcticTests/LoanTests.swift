import XCTest
@testable import Arctic

final class LoanTests: XCTestCase {
    func testInit() throws {
        let loan = Loan(id: "mock-uuid")
        XCTAssertNotNil(loan)
    }
}
