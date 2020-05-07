import Foundation

extension Bundle {
    
    static var eurofurenceModel: Bundle {
        Bundle(for: BundleScopingClass.self)
    }
    
}

private class BundleScopingClass {}
