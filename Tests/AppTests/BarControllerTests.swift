@testable import App
import XCTest
import Vapor

class BarControllerTests: XCTestCase {

    var app: Application!

    static let allTests = [
        ("queryReturnsBars", queryReturnsBars)
    ]

    override func setUp() {
        super.setUp()

        app = try! Application.testable()
    }

    override func tearDown() {
        super.tearDown()

    }

    func queryReturnsBars() throws {

        let response = try app.sendRequest(to: "/bars?city=san%20diego", method: .GET, body: "")

        let bars = try response.content.decode([Bar].self).wait()

        print(bars)

        XCTAssertEqual(bars.count, 1)
    }
}
