import Foundation

public struct LoginContentRepresentation: ContentRepresentation {
    
    public static func == (lhs: LoginContentRepresentation, rhs: LoginContentRepresentation) -> Bool {
        lhs.id == rhs.id
    }
    
    public var completionHandler: (Bool) -> Void
    private let id = UUID()
    
    public init(completionHandler: @escaping (Bool) -> Void) {
        self.completionHandler = completionHandler
    }
    
}
