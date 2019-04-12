import EurofurenceModel
import Foundation

class StubForceRefreshRequired: ForceRefreshRequired {

    var isForceRefreshRequired: Bool
    
    func markForceRefreshNoLongerRequired() {
        isForceRefreshRequired = false
    }
    
    init(isForceRefreshRequired: Bool) {
        self.isForceRefreshRequired = isForceRefreshRequired
    }

}
