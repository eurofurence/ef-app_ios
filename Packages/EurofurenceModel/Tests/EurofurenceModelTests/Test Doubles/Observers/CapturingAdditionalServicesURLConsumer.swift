import EurofurenceModel
import Foundation

class CapturingAdditionalServicesURLConsumer: AdditionalServicesURLConsumer {
    
    private(set) var consumedAdditionalServicesURLRequest: URLRequest?
    func consume(_ additionalServicesURLRequest: URLRequest) {
        consumedAdditionalServicesURLRequest = additionalServicesURLRequest
    }
    
}
