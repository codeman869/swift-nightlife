import Vapor

final class YelpAPI : NightLifeAPI {


    func getBusinesses(near city: String, matching term: String? = nil, on worker: Worker) throws -> Future<[Bar]> { 
    
    
      guard let token = Environment.get("API_TOKEN") else {
        print("Unable to determine API Key")
        throw VaporError(identifier: "No API Key", reason: "API Key is Missing!") 
      }
      
       guard let urlEncodedString = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
           throw Abort(.badRequest, reason: "Invalid location")
       }
       
    
       return HTTPClient.connect(scheme: .https, hostname: "api.yelp.com", on: worker).flatMap { client in
       
            let url = "/v3/businesses/search?location=\(urlEncodedString)&category=nightlife"
            
            var httpRequest = HTTPRequest(method: .GET, url: url , headers: .init()) 
            httpRequest.headers.add(name: "Authorization", value: "Bearer \(token)")
            httpRequest.headers.add(name: "Accept", value: "application/json")
            
            return try self.getBusinessesWith(request: httpRequest, client: client, on: worker)
           
        }
        
       
    }
    
    func getBusinessesBy(latitude lat: Double, longitude long: Double, on worker: Worker) throws -> Future<[Bar]>{
     guard let token = Environment.get("API_TOKEN") else {
        print("Unable to determine API Key")
        throw VaporError(identifier: "No API Key", reason: "API Key is Missing!") 
      }
          
        
       return HTTPClient.connect(scheme: .https, hostname: "api.yelp.com", on: worker).flatMap { client in
       
    
            let url = "/v3/businesses/search?latitude=\(lat)&longitude=\(long)&category=nightlife"
            
            var httpRequest = HTTPRequest(method: .GET, url: url, headers: .init())
            httpRequest.headers.add(name: "Authorization", value: "Bearer \(token)")
            httpRequest.headers.add(name: "Accept", value: "application/json")
   
            return try self.getBusinessesWith(request: httpRequest, client: client, on: worker)
            
            
       
       }
    
    }
    
    private func getBusinessesWith(request req: HTTPRequest, client: HTTPClient, on worker: Worker) throws -> Future<[Bar]> {
    
        return client.send(req).flatMap(to: [Bar].self) { response in
        
            return try JSONDecoder().decode(BusinessContent.self, from: response, maxSize: 1024 * 1024, on: worker).map { business in
            
                return business.businesses
            
            }   
       
        }
        
    }
    
}

protocol NightLifeAPI { }

struct Bar : Content {
    var id: String
    var name: String
    var image_url: String
    var review_count: Int
    var rating: Double
    var coordinates: Coordinates
    var location: Address
    var phone: String
}

struct BusinessContent : Content {
    var businesses : [Bar]
}

struct Coordinates : Content {
    var latitude: Double
    var longitude: Double
}

struct Address : Content {
    var address1: String
    var address2: String?
    var city: String
    var zip_code: String
}