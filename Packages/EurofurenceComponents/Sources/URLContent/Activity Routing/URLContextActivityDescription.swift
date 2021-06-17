#if canImport(UIKit)

import UIKit

@available(iOS 13.0, *)
public struct URLContextActivityDescription: ActivityDescription {
    
    private let URLContexts: Set<UIOpenURLContext>
    
    public init(URLContexts: Set<UIOpenURLContext>) {
        self.URLContexts = URLContexts
    }
    
    public func describe(to visitor: ActivityDescriptionVisitor) {
        guard let first = URLContexts.first else { return }
        visitor.visitURL(first.url)
    }
    
}

#endif
