import Foundation

public protocol CompanionAppURLRequestFactory {
    
    func makeAdditionalServicesRequest(authenticationToken: String?) -> URLRequest
    
}
