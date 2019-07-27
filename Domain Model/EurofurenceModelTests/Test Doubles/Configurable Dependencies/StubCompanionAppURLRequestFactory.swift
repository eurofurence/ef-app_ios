import EurofurenceModel
import Foundation

class StubCompanionAppURLRequestFactory: CompanionAppURLRequestFactory {
    
    let unauthenticatedAdditionalServicesRequest = URLRequest(url: .random)
    let authenticatedAdditionalServicesRequest = URLRequest(url: .random)
    
    private(set) var additionalServicesAuthenticationToken: String?
    func makeAdditionalServicesRequest(authenticationToken: String?) -> URLRequest {
        additionalServicesAuthenticationToken = authenticationToken
        return authenticationToken == nil ? unauthenticatedAdditionalServicesRequest : authenticatedAdditionalServicesRequest
    }
    
}
