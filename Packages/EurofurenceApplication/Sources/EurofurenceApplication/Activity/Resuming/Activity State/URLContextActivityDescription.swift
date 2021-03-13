import UIKit

@available(iOS 13.0, *)
struct URLContextActivityDescription: ActivityDescription {
    
    var URLContexts: Set<UIOpenURLContext>
    
    func describe(to visitor: ActivityDescriptionVisitor) {
        guard let first = URLContexts.first else { return }
        visitor.visitURL(first.url)
    }
    
}
