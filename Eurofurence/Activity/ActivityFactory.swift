import Foundation

protocol ActivityFactory {
    
    func makeActivity(type: String, title: String, url: URL?) -> Activity
    
}
