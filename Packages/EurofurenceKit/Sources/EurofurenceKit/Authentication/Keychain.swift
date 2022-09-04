public protocol Keychain: AnyObject {
    
    var credential: Credential? { get set }
    
}
