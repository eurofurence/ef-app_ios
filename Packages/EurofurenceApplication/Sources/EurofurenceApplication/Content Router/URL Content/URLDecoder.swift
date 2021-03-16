import EurofurenceComponentBase
import Foundation

protocol URLDecoder {
    
    func describe(url: URL, to recipient: ContentRepresentationRecipient) -> Bool
    
}
