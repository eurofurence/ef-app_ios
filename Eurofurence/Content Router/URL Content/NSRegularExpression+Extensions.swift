import Foundation

extension NSRegularExpression {
    
    convenience init(unsafePattern: String) {
        do {
            try self.init(pattern: unsafePattern, options: [])
        } catch {
            fatalError("Pattern \(unsafePattern) is not a valid regular expression")
        }
    }
    
}
