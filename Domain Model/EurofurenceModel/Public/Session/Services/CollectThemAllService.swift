import Foundation

public protocol CollectThemAllService {

    func subscribe(_ observer: CollectThemAllURLObserver)

}

public protocol CollectThemAllURLObserver {

    func collectThemAllGameRequestDidChange(_ urlRequest: URLRequest)

}
