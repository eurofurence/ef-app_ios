import EurofurenceModel
import Foundation

public class FakeAdditionalServicesRepository: AdditionalServicesRepository {
    
    public let urlRequest = URLRequest(url: .random)
    
    public init() {
        
    }
    
    public func add(_ additionalServicesURLConsumer: AdditionalServicesURLConsumer) {
        additionalServicesURLConsumer.consume(urlRequest)
    }
    
}
