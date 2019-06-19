@testable import App
import XCTest
import Vapor
import FluentPostgreSQL

class UserTests: XCTestCase {
    let usersName = "Jahnel Cruz"
    let email = "bob@example.org"
    let password = "password"
    var app: Application!
    var conn: PostgreSQLConnection!

    override func setUp() {
        super.setUp()
        // swiftlint:disable force_try
        app = try! Application.testable()

        conn = try! app.newConnection(to: .psql).wait()

        _ = try! conn.raw("DELETE FROM \"User\"").all().wait()

        // swiftlint:enable force_try

    }

    override func tearDown() {
        super.tearDown()

        conn.close()
    }

    func createSavesAUser() throws {

        let user = CreateUserRequest(name: usersName, email: email, password: password, verifyPassword: password)

        let response = try app.sendRequest(to: "/users", method: .POST, body: user)

        let userResponse = try response.content.decode(UserResponse.self).wait()

        XCTAssertEqual(userResponse.email, email)
        XCTAssertNotNil(userResponse.id)

    }

    func emailIDIsUnique() throws {

        let user = CreateUserRequest(name: usersName, email: email, password: password, verifyPassword: password)

        let response = try app.sendRequest(to: "/users", method: .POST, body: user)

        _ = try response.content.decode(UserResponse.self).wait()

        let response2 = try app.sendRequest(to: "/users", method: .POST, body: user)

        XCTAssertEqual(response2.http.status, HTTPStatus.badRequest)
        XCTAssertThrowsError(try response2.content.decode(UserResponse.self).wait())
    }

    static let allTests = [
        ("createSavesAUser", createSavesAUser),
        ("emailIDIsUnique", emailIDIsUnique)
    ]
}
