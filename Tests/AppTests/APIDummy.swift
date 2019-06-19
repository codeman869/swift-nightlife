@testable import App
import Vapor

final class APIDummy: NightLifeAPI {

    static let barName = "Good Ol' Saloon"
    static let barId = "abcd1234"
    static let barPic = "https://www.google.com"
    static let barPhone = "555-1212"
    static let reviews = 100
    static let rating = 4.3

    // MARK: - ServiceType Protocol

    static var serviceSupports: [Any.Type] {
        return [Logger.self]
    }

    static func makeService(for worker: Container) throws -> APIDummy {
        return APIDummy()
    }

    // MARK: - NightLifeAPI Protocol

    func getBusinessesBy(latitude lat: Double, longitude long: Double, on worker: Worker) throws -> Future<[Bar]> {

        let testBar = self.getBar()

        var retArr = [Bar]()

        retArr.append(testBar)

        let promise = worker.eventLoop.newPromise([Bar].self)

        promise.succeed(result: retArr)

        return promise.futureResult

    }

    func getBusinesses(near city: String, matching term: String?, on worker: Worker) throws -> Future<[Bar]> {

        let testBar = self.getBar()

        var retArr = [Bar]()

        retArr.append(testBar)

        let promise = worker.eventLoop.newPromise([Bar].self)
        promise.succeed(result: retArr)

        return promise.futureResult

    }
// swiftlint:disable identifier_name
    func getBusiness(id: String, on worker: Worker) throws -> Future<Bar> {

        guard id == self.getBar().id else {
            throw Abort(.badRequest, reason: "Invalid BarID")
        }

        let testBar = self.getBar()

        let promise = worker.eventLoop.newPromise(Bar.self)
        promise.succeed(result: testBar)

        return promise.futureResult
    }
// swiftlint:enable identifier_name
    private func getBar() -> Bar {

        let coords: Coordinates = Coordinates(lat: 123.773, long: -124.12)

        let address = Address(add1: "1234 NE 82nd Ave", city: "San Diego", zip: "92108")

        return Bar(id: APIDummy.barId, name: APIDummy.barName, image: APIDummy.barPic, reviews: APIDummy.reviews,
                    rating: APIDummy.rating, coords: coords, location: address, phone: APIDummy.barPhone )

    }

}
