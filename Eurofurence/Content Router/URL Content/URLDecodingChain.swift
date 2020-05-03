import Foundation

struct URLDecodingChain {
    
    private var decoders = [URLDecoder]()
    
    mutating func add(_ decoder: URLDecoder) {
        decoders.append(decoder)
    }
    
    func describe(url: URL, to recipient: ContentRepresentationRecipient) {
        for decoder in decoders {
            if decoder.describe(url: url, to: recipient) {
                return
            }
        }
    }
    
}
