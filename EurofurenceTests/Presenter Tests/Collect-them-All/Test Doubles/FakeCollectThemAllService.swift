import EurofurenceModel
import Foundation

class FakeCollectThemAllService: CollectThemAllService {

    let urlRequest = URLRequest(url: .random)
    func subscribe(_ observer: CollectThemAllURLObserver) {
        observer.collectThemAllGameRequestDidChange(urlRequest)
    }

}
