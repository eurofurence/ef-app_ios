import Foundation

public protocol ForceRefreshRequired {

    var isForceRefreshRequired: Bool { get }
    
    func markForceRefreshNoLongerRequired()

}
