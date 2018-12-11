import Vapor

final class YelpAPI : NightLifeAPI {


    func getBusinesses(on worker: Worker) throws -> Future<[Bar]> { 
    
    
      guard let token = Environment.get("API_TOKEN") else {
        print("Unable to determine API Key")
        throw VaporError(identifier: "No API Key", reason: "API Key is Missing!") 
      }
    
       return HTTPClient.connect(scheme: .https, hostname: "api.yelp.com", on: worker).flatMap { client in
            
            var httpRequest = HTTPRequest(method: .GET, url: "/v3/businesses/search?location=portland&category=nightlife", headers: .init()) 
            httpRequest.headers.add(name: "Authorization", value: "Bearer \(token)")
            httpRequest.headers.add(name: "Accept", value: "application/json")
            
            return try client.send(httpRequest).flatMap(to: [Bar].self) { req in 
               /* 
                guard let data = req.body.data else {
                    throw VaporError(identifier: "No API Response", reason: "Received an empty response from Yelp API")
                }
               */ 
               
                
                return try JSONDecoder().decode(BusinessContent.self, from: req, maxSize: 1024 * 1024, on: worker).map { business in
                
                    return business.businesses
                
                }
                
                
            }
            
        }
        
       
    }
    
}

protocol NightLifeAPI { }

struct Bar : Content {
    var id: String
    var name: String
    var image_url: String
    //var is_closed: Boolean
    var review_count: Int
    var rating: Double
}

struct BusinessContent : Content {
    var businesses : [Bar]
}