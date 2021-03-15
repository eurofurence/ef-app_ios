import Foundation

public protocol AdditionalServicesRepository {
    
    func add(_ additionalServicesURLConsumer: AdditionalServicesURLConsumer)
    
}

public protocol AdditionalServicesURLConsumer {
    
    func consume(_ additionalServicesURLRequest: URLRequest)
    
}
