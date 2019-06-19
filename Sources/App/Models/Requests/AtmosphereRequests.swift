import Vapor
/// Data required to create an atmosphere.
struct AtmosphereRequest: Content {
    /// The BarID being rated.
    var barID: String
    /// Awesomeness Rating.
    var awesomeness: Double
    /// Busyness Rating.
    var busyness: Double

}
