import EurofurenceModel
import Foundation

public class FakeCollectThemAllService: CollectThemAllService {
    
    public init() {
        
    }

    public let urlRequest = URLRequest(url: .random)
    public func subscribe(_ observer: CollectThemAllURLObserver) {
        observer.collectThemAllGameRequestDidChange(urlRequest)
    }

}
