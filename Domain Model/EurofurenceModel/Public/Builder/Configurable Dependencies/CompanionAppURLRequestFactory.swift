import Foundation

public protocol CompanionAppURLRequestFactory {
    
    func makeAdditionalServicesRequest() -> URLRequest
    
}
