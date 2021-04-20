import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PTCGPlayerBoardTests.allTests),
        testCase(PTCGDeckSetTests.allTests),
    ]
}
#endif
