import Foundation

protocol ExpressibleBySingleParameterURL: ExpressibleByURL {
    
    static var regularExpression: NSRegularExpression { get }
    
    associatedtype CaptureGroupContents: ExpressibleByString
    
    init(singleParameterCaptureGroup: CaptureGroupContents)
    
}

// MARK: - Default ExpressibleByURL Implementation

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
