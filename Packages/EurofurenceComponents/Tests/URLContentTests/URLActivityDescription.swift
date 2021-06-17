import Foundation
import URLContent

struct URLActivityDescription: ActivityDescription {
    
    var url: URL
    
    func describe(to visitor: ActivityDescriptionVisitor) {
        visitor.visitURL(url)
    }
    
}
