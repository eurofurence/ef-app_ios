import EurofurenceModel
import UIKit

public struct BackgroundFetchService {
    
    private let refreshService: RefreshService
    
    public init(refreshService: RefreshService) {
        self.refreshService = refreshService
    }
    
    public func executeFetch(
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        refreshService.refreshLocalStore { (error) in
            if error == nil {
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        }
    }
    
}
