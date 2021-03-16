import EurofurenceComponentBase
import Foundation

struct DecodeContentFromURL<T>: URLDecoder
    where T: ExpressibleByURL, T: ContentRepresentation {
    
    func describe(url: URL, to recipient: ContentRepresentationRecipient) -> Bool {
        if let content = T(url: url) {
            recipient.receive(content)
            return true
        } else {
            return false
        }
    }
    
}
