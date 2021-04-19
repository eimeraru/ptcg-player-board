import XCTest
@testable import PTCGPlayerBoard

final class PTCGPlayerBoardTests: XCTestCase {
    func testExample() {
        XCTAssertEqual(PTCGPlayerBoard().text, "Hello, World!")
        XCTAssertEqual(PTCGPlayerBoard().sandbox().currentHitPoint, 0)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
