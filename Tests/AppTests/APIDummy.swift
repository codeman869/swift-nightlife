@testable import App
import Vapor

final class APIDummy: NightLifeAPI {

    // MARK: - ServiceType Protocol

    static var serviceSupports: [Any.Type] {
        return [Logger.self]
    }

    static func makeService(for worker: Container) throws -> APIDummy {
        return APIDummy()
    }

    // MARK: - NightLifeAPI Protocol

    func getBusinessesBy(latitude lat: Double, longitude long: Double, on worker: Worker) throws -> Future<[Bar]> {

        let coords: Coordinates = Coordinates(lat: 123.773, long: -124.12)

        let address = Address(add1: "1234 NE 82nd Ave", city: "San Diego", zip: "92108")

        let testBar = Bar(id: "abcd1234", name: "Good Ol' Saloon", image: "http://google.com", reviews: 100, rating: 4.3, coords: coords, location: address, phone: "555-1212")

        var retArr = [Bar]()

        retArr.append(testBar)

        let promise = worker.eventLoop.newPromise([Bar].self)

        promise.succeed(result: retArr)

        return promise.futureResult
       // return Future(retArr) 

    }

    func getBusinesses(near city: String, matching term: String?, on worker: Worker) throws -> Future<[Bar]> {

        let coords: Coordinates = Coordinates(lat: 123.773, long: -124.12)

        let address = Address(add1: "1234 NE 82nd Ave", city: "San Diego", zip: "92108")

        let testBar = Bar(id: "abcd1234", name: "Good Ol' Saloon", image: "http://google.com", reviews: 100, rating: 4.3, coords: coords, location: address, phone: "555-1212")

        var retArr = [Bar]()

        retArr.append(testBar)

        let promise = worker.eventLoop.newPromise([Bar].self)
        promise.succeed(result: retArr)

        return promise.futureResult

    }

}
