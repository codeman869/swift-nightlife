import Vapor

/// Main Class for interacting with  the YelpAPI and the  
final class BarController {

    func getBars(_ req: Request) throws -> Future<HTTPStatus> {
        let api = YelpAPI()
        
        //try api.getBusiness(on: req)
        
        return try api.getBusinesses(on: req).map(to: HTTPStatus.self) { resp in
        
            print(resp)
            return .ok
            
        }
        
    
       
    }

}
