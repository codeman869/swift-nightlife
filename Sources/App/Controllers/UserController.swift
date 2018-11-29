import Crypto
import Vapor
import FluentPostgreSQL

/// Creates new users and logs them in.
final class UserController {
    /// Logs a user in, returning a token for accessing protected endpoints.
    func login(_ req: Request) throws -> Future<Token> {
        /*  
        // get user auth'd by basic auth middleware
        let user = try req.requireAuthenticated(User.self)
        
        // create new token for this user
        */
        
        return try req.content.decode(LoginUserRequest.self).flatMap { user in
        
            return User.query(on: req).filter(\.email == user.email).first().flatMap { fetchedUser in
            
                guard let existingUser = fetchedUser else {
                    throw Abort(HTTPStatus.notFound)
                }
                
                let hasher = try req.make(BCryptDigest.self)
                
                if try hasher.verify(user.password, created: existingUser.password) {
                
                    return try Token.query(on: req)
                        .filter(\Token.userID == existingUser.requireID())
                        .delete(force: true).flatMap { _ in
                
                        let token = try Token.create(userID: existingUser.requireID())
                
                        // save and return token
                        return token.save(on: req)
                    
                    }
                
                } else {
                    throw Abort(HTTPStatus.unauthorized)
                }
                
                
            
            }
            
            
            
        }
        
        
       
    }
    
    /// Creates a new user.
    func create(_ req: Request) throws -> Future<UserResponse> {
        // decode request content
        return try req.content.decode(CreateUserRequest.self).flatMap { user -> Future<User> in
            // verify that passwords match
            guard user.password == user.verifyPassword else {
                throw Abort(.badRequest, reason: "Password and verification must match.")
            }
            
            // hash user's password using BCrypt
            let hash = try BCrypt.hash(user.password)
            // save new user
            return User(id: nil, name: user.name, email: user.email, password: hash)
                .save(on: req)
        }.map { user in
            // map to public user response (omits password hash)
            return try UserResponse(id: user.requireID(), name: user.name, email: user.email)
        }
    }
}

// MARK: Content

/// Data required to create a user.
struct CreateUserRequest: Content {
    /// User's full name.
    var name: String
    
    /// User's email address.
    var email: String
    
    /// User's desired password.
    var password: String
    
    /// User's password repeated to ensure they typed it correctly.
    var verifyPassword: String
}

/// Login Request Structure
struct LoginUserRequest: Content {
    var email: String
    var password: String
}

/// Public representation of user data.
struct UserResponse: Content {
    /// User's unique identifier.
    /// Not optional since we only return users that exist in the DB.
    var id: Int
    
    /// User's full name.
    var name: String
    
    /// User's email address.
    var email: String
}
