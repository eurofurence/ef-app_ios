import Foundation

public protocol ActivityDescription {
    
    func describe(to visitor: ActivityDescriptionVisitor)
    
}

public protocol ActivityDescriptionVisitor {
    
    func visitIntent(_ intent: AnyHashable)
    func visitURL(_ url: URL)
    
}
