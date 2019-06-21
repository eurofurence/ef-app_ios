import EurofurenceModel
import Foundation

class StubCompanionAppURLRequestFactory: CompanionAppURLRequestFactory {
    
    let additionalServicesRequest = URLRequest(url: .random)
    func makeAdditionalServicesRequest() -> URLRequest {
        return additionalServicesRequest
    }
    
}
