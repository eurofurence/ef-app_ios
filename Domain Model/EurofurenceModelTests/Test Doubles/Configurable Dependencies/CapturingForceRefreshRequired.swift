import EurofurenceModel
import Foundation

class CapturingForceRefreshRequired: ForceRefreshRequired {

    private(set) var wasEnquiredWhetherForceRefreshRequired = false
    var isForceRefreshRequired: Bool {
        wasEnquiredWhetherForceRefreshRequired = true
        return true
    }
    
    func markForceRefreshNoLongerRequired() {
        
    }

}
