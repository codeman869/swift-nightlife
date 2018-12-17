import Vapor
/// Public representation of user data.
//swiftlint:disable identifier_name
struct UserResponse: Content {
    /// User's unique identifier.
    /// Not optional since we only return users that exist in the DB.
    var id: Int

    /// User's full name.
    var name: String

    /// User's email address.
    var email: String
}
