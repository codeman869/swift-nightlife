import Vapor
import FluentPostgreSQL

final class AtmosphereController {

    func rateBar(_ req: Request) throws -> Future<Atmosphere> {

        return try req.content.decode(AtmosphereRequest.self).flatMap { atmosReq -> Future<Atmosphere> in

            return Atmosphere.query(on: req).filter(\.barID == atmosReq.barID).first().flatMap { fetchedAtmosphere in

                guard let atmosphere = fetchedAtmosphere else {
                    //Create a new atmosphere
                    // To create a new atmosphere, we have to determine if the BarID is valid.

                    let api = try req.make(NightLifeAPI.self)

                    return try api.getBusiness(id: atmosReq.barID, on: req).flatMap(to: Atmosphere.self) { bar in
                        let today = Date()
                        let newAtmosphere = Atmosphere(barName: bar.name, barID: bar.id, date: today,
                                                   busyRating: atmosReq.busyness, awesomeRating: atmosReq.awesomeness,
                                                   votes: 1)

                        return newAtmosphere.save(on: req)
                    }

                }

                atmosphere.addRating(busyness: atmosReq.busyness, awesomeness: atmosReq.awesomeness)
                return try atmosphere.save(on: req)

            }

        }

    }
}
