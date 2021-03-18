import EurofurenceModel
import Foundation
import UIKit

public struct AppURLOpener: URLOpener {
    
    public static let shared = AppURLOpener()
    
    private init() {
        
    }

    public func open(_ url: URL) {
        UIApplication.shared.open(url)
    }

}
