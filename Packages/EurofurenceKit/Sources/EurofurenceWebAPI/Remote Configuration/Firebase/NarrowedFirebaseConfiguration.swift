import Foundation

protocol NarrowedFirebaseConfiguration {
    
    func acquireRemoteValues() async
    
    func remotelyConfiguredValue(forKey key: String) -> NarrowedFirebaseConfiguredValue?
    
}

protocol NarrowedFirebaseConfiguredValue {
    
    var numberValue: NSNumber { get }
    
}
