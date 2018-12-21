#if os(Linux)

import XCTest
@testable import AppTests

XCTMain([
    // AppTests
    testCase(UserTests.allTests),
    testCase(BarControllerTests.allTests)
])

#endif
