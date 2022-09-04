public class SecKeychain: Keychain {
    
    public static let shared = SecKeychain()
    
    private init() {
        
    }
    
    public var credential: Credential? = nil
    
}
