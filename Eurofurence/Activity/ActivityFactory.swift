import Foundation

public protocol ActivityFactory {
    
    func makeActivity(type: String, title: String, url: URL?) -> Activity
    
}
