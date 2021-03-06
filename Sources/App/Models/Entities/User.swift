import Authentication
import FluentPostgreSQL
import Vapor

/// A registered user, capable of owning todo items.
final class User: PostgreSQLModel {
    /// User's unique identifier.
    /// Can be `nil` if the user has not been saved yet.
    // swiftlint:disable:next identifier_name
    var id: Int?

    /// User's full name.
    var name: String

    /// User's email address.
    var email: String

    /// BCrypt hash of the user's password.
    var password: String

    /// Creates a new `User`.
    // swiftlint:disable:next identifier_name
    init(id: Int? = nil, name: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}

/// Allows users to be verified by bearer / token auth middleware.
extension User: TokenAuthenticatable {
    /// See `TokenAuthenticatable`.
    typealias TokenType = Token
}

/// Allows `User` to be used as a Fluent migration.
extension User: Migration {

    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(User.self, on: conn) { builder in

            try addProperties(to: builder)

            builder.unique(on: \.email)

        }
    }
}

/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }

/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }
