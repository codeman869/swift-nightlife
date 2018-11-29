import Vapor
import PostgreSQL

public func databases(config: inout DatabasesConfig) throws {
    
    guard let databaseUrl = Environment.get("DATABASE_URL") else {
        print("Unable to find database URL")
        print("\(Environment.get("DATABASE_URL"))")
        throw Abort(.internalServerError)
    }
    
    guard let dbConfig = PostgreSQLDatabaseConfig(url: databaseUrl) else {
        throw Abort(.internalServerError)
        
    }
    
    config.add(database: PostgreSQLDatabase(config: dbConfig), as: .psql)
    
    
}