import Foundation

protocol ActivityDescription {
    
    func describe(to visitor: ActivityDescriptionVisitor)
    
}

protocol ActivityDescriptionVisitor {
    
    func visitIntent(_ intent: Any)
    func visitURL(_ url: URL)
    
}
