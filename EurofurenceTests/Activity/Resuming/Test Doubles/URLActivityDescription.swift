import Eurofurence
import Foundation

struct URLActivityDescription: ActivityDescription {
    
    var url: URL
    
    func describe(to visitor: ActivityDescriptionVisitor) {
        visitor.visitURL(url)
    }
    
}
