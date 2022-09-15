import Foundation

extension Date: Identifiable {
    
    public var id: some Hashable {
        self
    }
    
}
