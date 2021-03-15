import Foundation

public protocol SessionStateService {

    func determineSessionState(completionHandler: @escaping (EurofurenceSessionState) -> Void)

}
