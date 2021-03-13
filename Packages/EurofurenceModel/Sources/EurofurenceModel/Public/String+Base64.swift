import Foundation

public extension String {
    
    var base64EncodedString: String {
        return data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
}
