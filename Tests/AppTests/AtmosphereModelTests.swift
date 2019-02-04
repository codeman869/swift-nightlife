@testable import App
import XCTest
import Vapor
import FluentPostgreSQL

class AtmosphereModelTests: XCTestCase {
    static let allTests = [
    ("ratingAtmosphere", ratingAtmosphere)
    ]

    func ratingAtmosphere() {
        let dummyDate = Date()
        let atmosphere = Atmosphere(id: nil, barName: "Ted's Bar", barID: "abcd1234", date: dummyDate, busyRating: 0,
            awesomeRating: 0, votes: 0)

        atmosphere.addRating(busyness: 5, awesomeness: 5)

        XCTAssertEqual(atmosphere.busyRating, 5)
        XCTAssertEqual(atmosphere.awesomeRating, 5)
        XCTAssertEqual(atmosphere.votes, 1)

        atmosphere.addRating(busyness: 1, awesomeness: 10)

        XCTAssertEqual(atmosphere.busyRating, 3)
        XCTAssertEqual(atmosphere.awesomeRating, 7.5)
        XCTAssertEqual(atmosphere.votes, 2)

    }
}
