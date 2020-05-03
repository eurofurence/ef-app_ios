import EurofurenceModel
import Foundation

public struct URLContentRepresentation: ContentRepresentation {
    
    private static var decodingChain: URLDecodingChain = {
        var chain = URLDecodingChain()
        chain.add(DecodeContentFromURL<EventContentRepresentation>())
        chain.add(DecodeContentFromURL<DealerContentRepresentation>())
        chain.add(DecodeContentFromURL<KnowledgeEntryContentRepresentation>())
        chain.add(DecodeContentFromURL<KnowledgeGroupsContentRepresentation>())
        
        return chain
    }()
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        Self.decodingChain.describe(url: url, to: recipient)
    }
    
}

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

protocol URLDecoder {
    
    func describe(url: URL, to recipient: ContentRepresentationRecipient) -> Bool
    
}

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

protocol ExpressibleByURL {
    
    init?(url: URL)
    
}

protocol ExpressibleByString {
    
    init?(stringValue: String)
    
}

protocol ExpressibleBySingleParameterURL: ExpressibleByURL {
    
    static var regularExpression: NSRegularExpression { get }
    
    associatedtype CaptureGroupContents: ExpressibleByString
    
    init(singleParameterCaptureGroup: CaptureGroupContents)
    
}

extension ExpressibleBySingleParameterURL {
    
    init?(url: URL) {
        let absoluteString = url.absoluteString
        let range = NSRange(location: 0, length: absoluteString.count)
        guard let match = Self.regularExpression.firstMatch(in: absoluteString, options: [], range: range) else {
            return nil
        }
        
        let r = match.range(at: max(0, match.numberOfRanges - 1))
        guard let captureGroupRange = Range(r, in: absoluteString) else {
            return nil
        }
        
        let captureGroupContents = String(absoluteString[captureGroupRange])
        guard let captureGroupValue = CaptureGroupContents(stringValue: captureGroupContents) else {
            return nil
        }
        
        self.init(singleParameterCaptureGroup: captureGroupValue)
    }
    
}

extension Identifier: ExpressibleByString {
    
    init?(stringValue: String) {
        self.init(stringValue)
    }
    
}

extension NSRegularExpression {
    
    convenience init(unsafePattern: String) {
        do {
            try self.init(pattern: unsafePattern, options: [])
        } catch {
            fatalError("Pattern \(unsafePattern) is not a valid regular expression")
        }
    }
    
}

extension EventContentRepresentation: ExpressibleBySingleParameterURL {
    
    static var regularExpression = NSRegularExpression(unsafePattern: #"Events/(.*)"#)
    
    typealias CaptureGroupContents = EventIdentifier
    
    init(singleParameterCaptureGroup: EventIdentifier) {
        self.init(identifier: singleParameterCaptureGroup)
    }
    
}

extension DealerContentRepresentation: ExpressibleBySingleParameterURL {
    
    static var regularExpression = NSRegularExpression(unsafePattern: #"Dealers/(.*)"#)
    
    typealias CaptureGroupContents = DealerIdentifier
    
    init(singleParameterCaptureGroup: DealerIdentifier) {
        self.init(identifier: singleParameterCaptureGroup)
    }
    
}

extension KnowledgeEntryContentRepresentation: ExpressibleBySingleParameterURL {
    
    static var regularExpression = NSRegularExpression(unsafePattern: #"KnowledgeEntries/(.*)"#)
    
    typealias CaptureGroupContents = KnowledgeEntryIdentifier
    
    init(singleParameterCaptureGroup: KnowledgeEntryIdentifier) {
        self.init(identifier: singleParameterCaptureGroup)
    }
    
}

extension KnowledgeGroupsContentRepresentation: ExpressibleByURL {
    
    init?(url: URL) {
        guard url.path.contains("KnowledgeGroups") else { return nil }
    }
    
}
