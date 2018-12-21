import Vapor

/// Main Class for interacting with  the YelpAPI and the  
final class BarController {

    func getBars(_ req: Request) throws -> Future<[Bar]> {

        let api = try req.make(NightLifeAPI.self)

        if let city = req.query[String.self, at: "city"] {
          return try api.getBusinesses(near: city, matching: nil, on: req).map(to: [Bar].self) { resp in

            return resp

          }

        } else if let lat = req.query[Double.self, at: "lat"], let long = req.query[Double.self, at: "long"] {

             return try api.getBusinessesBy(latitude: lat, longitude: long, on: req).map(to: [Bar].self) { resp in

                return resp

            }

        } else {
            throw Abort(.badRequest, reason: "Location is required for a search")
        }

    }

}
