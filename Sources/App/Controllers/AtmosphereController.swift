import Vapor
import FluentPostgreSQL

final class AtmosphereController {

    func rateBar(_ req: Request) throws -> Future<Atmosphere> {

        return try req.content.decode(AtmosphereRequest.self).flatMap { atmosReq -> Future<Atmosphere> in

            return Atmosphere.query(on: req).filter(\.barID == atmosReq.barID).first().flatMap { fetchedAtmosphere in

                guard let atmosphere = fetchedAtmosphere else {
                    //Create a new atmosphere
                    let today = Date()
                    let newAtmosphere = Atmosphere(barName: "test", barID: "abcd1234", date: today,
                                                   busyRating: atmosReq.busyness, awesomeRating: atmosReq.awesomeness,
                                                   votes: 1)

                    return newAtmosphere.save(on: req)

                }

                atmosphere.addRating(busyness: atmosReq.busyness, awesomeness: atmosReq.awesomeness)
                return try atmosphere.save(on: req)

            }

        }

    }
}

struct AtmosphereRequest: Codable {

    var barID: String
    var awesomeness: Double
    var busyness: Double

}
