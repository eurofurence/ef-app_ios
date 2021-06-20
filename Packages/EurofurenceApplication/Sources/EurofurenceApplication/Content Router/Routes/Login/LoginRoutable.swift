import Foundation
import RouterCore

public struct LoginRouteable: Routeable {
    
    public static func == (lhs: LoginRouteable, rhs: LoginRouteable) -> Bool {
        lhs.id == rhs.id
    }
    
    public var completionHandler: (Bool) -> Void
    private let id = UUID()
    
    public init(completionHandler: @escaping (Bool) -> Void) {
        self.completionHandler = completionHandler
    }
    
}
