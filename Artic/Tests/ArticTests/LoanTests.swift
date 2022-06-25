import XCTest
@testable import Artic

final class LoanTests: XCTestCase {
    func testInit() throws {
        let loan = Loan(id: "mock-uuid")
        XCTAssertNotNil(loan)
    }
}
