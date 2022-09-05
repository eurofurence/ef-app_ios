import EurofurenceKit

class SpyKeychain<K>: Keychain where K: Keychain {
    
    private let spying: K
    
    init(_ spying: K) {
        self.spying = spying
    }
    
    private(set) var setCredential: Credential?
    var credential: Credential? {
        get {
            spying.credential
        }
        set {
            setCredential = newValue
            spying.credential = newValue
        }
    }
    
}
