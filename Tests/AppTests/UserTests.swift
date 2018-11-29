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
        
        app = try! Application.testable()
        
        conn = try! app.newConnection(to: .psql).wait()
        
        _ = try! conn.raw("DELETE FROM \"User\"").all().wait()
       
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
   
   
    static let allTests = [
        ("createSavesAUser", createSavesAUser),
    ]
}