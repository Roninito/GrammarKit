import XCTest
@testable import GrammarKit

final class GrammarKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(GrammarKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
