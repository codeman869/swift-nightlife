@testable import App
import XCTest
import Vapor
import FluentPostgreSQL

class AtmosphereControllerTests: XCTestCase {

    var app: Application!
    var conn: PostgreSQLConnection!

    static let allTests = [
        ("post to /bars creates an Atmosphere", postCreatesAtmosphere),
        ("invalid barID is Bad Request", invalidBarIDBadRequest)
    ]

    override func setUp() {
        super.setUp()
        //swiftlint:disable force_try
        app = try! Application.testable()
        conn = try! app.newConnection(to: .psql).wait()
        _ = try! conn.raw("DELETE FROM \"Atmosphere\"").all().wait()
        //swiftlint:enable force_try
    }

    override func tearDown() {
        super.tearDown()

    }

    func postCreatesAtmosphere() throws {

        let atmosphereReq = AtmosphereRequest(barID: APIDummy.barId, awesomeness: 7, busyness: 8)

        let response = try app.sendRequest(to: "/bars", method: .POST, body: atmosphereReq)

        let atmosphereResponse = try response.content.decode(Atmosphere.self).wait()

        let atmospheres = try Atmosphere.query(on: conn).all().wait()

        XCTAssertEqual(response.http.status, HTTPStatus.ok)
        XCTAssertEqual(atmospheres.count, 1)
        XCTAssertEqual(atmospheres[0].barID, APIDummy.barId)
        XCTAssertEqual(atmospheres[0].barName, APIDummy.barName)
        XCTAssertEqual(atmospheres[0].awesomeRating, 7)
        XCTAssertEqual(atmospheres[0].busyRating, 8)
        XCTAssertEqual(atmospheres[0].votes, 1)
    }

    func invalidBarIDBadRequest() throws {
        let atmosphereReq = AtmosphereRequest(barID: "\(APIDummy.barId)z", awesomeness: 7, busyness: 8)
        let response = try app.sendRequest(to: "/bars", method: .POST, body: atmosphereReq)

        XCTAssertEqual(response.http.status, HTTPStatus.badRequest)
    }

}
