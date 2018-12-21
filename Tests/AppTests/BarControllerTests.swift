@testable import App
import XCTest
import Vapor

class BarControllerTests: XCTestCase {

    var app: Application!

    static let allTests = [
        ("queryReturnsBars", queryReturnsBars),
        ("noLocationIsBadRequest", noLocationIsBadRequest),
        ("locationCanBeLatLong", locationCanBeLatLong),
        ("latAndLongAreRequired", latAndLongAreRequired)
    ]

    override func setUp() {
        super.setUp()
        //swiftlint:disable:next force_try
        app = try! Application.testable()
    }

    override func tearDown() {
        super.tearDown()

    }

    func queryReturnsBars() throws {

        let response = try app.sendRequest(to: "/bars?city=san%20diego", method: .GET, body: "")

        let bars = try response.content.decode([Bar].self).wait()
        let bar = bars[0]

        XCTAssertEqual(bar.name, APIDummy.barName)
        XCTAssertEqual(bar.id, APIDummy.barId)
        XCTAssertEqual(bar.image_url, APIDummy.barPic)
        XCTAssertEqual(bar.review_count, APIDummy.reviews)
        XCTAssertEqual(bar.rating, APIDummy.rating)

        XCTAssertEqual(bars.count, 1)

    }

    func noLocationIsBadRequest() throws {
        let response = try app.sendRequest(to: "/bars", method: .GET, body: "")

        XCTAssertEqual(response.http.status, HTTPStatus.badRequest)

    }

    func locationCanBeLatLong() throws {
        let response = try app.sendRequest(to: "/bars?lat=45.39&long=-127.49", method: .GET, body: "")

        let bars = try response.content.decode([Bar].self).wait()

        XCTAssertEqual(bars.count, 1)

    }

    func latAndLongAreRequired() throws {
        let response = try app.sendRequest(to: "/bars?lat=45.39", method: .GET, body: "")

        XCTAssertEqual(response.http.status, HTTPStatus.badRequest)

        let response2 = try app.sendRequest(to: "/bars?long=122.39", method: .GET, body: "")

        XCTAssertEqual(response.http.status, HTTPStatus.badRequest)
    }
}
