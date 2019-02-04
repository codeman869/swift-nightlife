import FluentPostgreSQL
import Vapor

/// An atmosphere, identifying a place based on votes 
final class Atmosphere: PostgreSQLModel {
    /// Unique identifier for the Atmosphere rating.
    /// Can be `nil` if it has not been saved yet.
    // swiftlint:disable:next identifier_name
    var id: Int?

    /// Name of the bar.
    var barName: String

    /// YelpID
    var barID: String

    /// How busy is the place - Scale of 1 - 10 
    var busyRating: Double

    /// How is the atmosphere - Scale of 1 - 10
    var awesomeRating: Double

    /// Number of Votes
    var votes: Int

    var date: Date

    /// Creates a new `Atmosphere`.
    // swiftlint:disable:next identifier_name
    init(id: Int? = nil, barName: String, barID: String, date: Date, busyRating: Double,
         awesomeRating: Double, votes: Int ) {
        self.id = id
        self.barName = barName
        self.barID = barID
        self.date = date
        self.busyRating = busyRating
        self.awesomeRating = awesomeRating
        self.votes = votes
    }

    func addRating(busyness: Double, awesomeness: Double) {

        let totalAwesome = awesomeRating * Double(votes) + awesomeness
        let totalBusy = busyRating * Double(votes) + busyness

        self.votes += 1

        self.busyRating = totalBusy / Double(votes)
        self.awesomeRating = totalAwesome / Double(votes)

    }
}

/// Allows `Atmosphere` to be used as a Fluent migration.
extension Atmosphere: Migration {

    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(Atmosphere.self, on: conn) { builder in

            try addProperties(to: builder)

            builder.unique(on: \.barID)

        }
    }
}

/// Allows `Atmosphere` to be encoded to and decoded from HTTP messages.
extension Atmosphere: Content { }

/// Allows `Atmosphere` to be used as a dynamic parameter in route definitions.
extension Atmosphere: Parameter { }
