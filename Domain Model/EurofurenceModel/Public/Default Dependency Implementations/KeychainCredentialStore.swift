import Foundation
import Security

public struct KeychainCredentialStore: CredentialStore {
    
    private var userAccount: String
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    public init(userAccount: String = "Eurofurence") {
        self.userAccount = userAccount
    }
    
    public var persistedCredential: Credential? {
        var item: CFTypeRef?
        SecItemCopyMatching(makeMutableLoginCredentialQuery(), &item)
        
        return parseCredentialFromKeychainItem(item)
    }
    
    public func store(_ credential: Credential) {
        // The keychain API needs the previous value for the query to be clear before
        // updating it, otherwise it pollutes the new value. In our case this makes the
        // stored credential data garbage and can't be decoded.
        deletePersistedToken()
        
        let keychainItem = KeychainItemAttributes.fromCredential(credential)
        guard let keychainItemData = try? encoder.encode(keychainItem) else { return }
        
        storeCredentialData(keychainItemData)
    }
    
    public func deletePersistedToken() {
        SecItemDelete(makeMutableLoginCredentialQuery())
    }
    
    private func makeMutableLoginCredentialQuery() -> NSMutableDictionary {
        return [kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: userAccount,
                kSecReturnData: kCFBooleanTrue as Any] as NSMutableDictionary
    }
    
    private func copyItemFromKeychain() -> CFTypeRef? {
        var item: CFTypeRef?
        SecItemCopyMatching(makeMutableLoginCredentialQuery(), &item)
        
        return item
    }
    
    private func parseCredentialFromKeychainItem(_ item: CFTypeRef?) -> Credential? {
        var credential: Credential?
        if let data = item as? NSData {
            let keychainItem = try? decoder.decode(KeychainItemAttributes.self, from: data as Data)
            credential = keychainItem?.credential
        }
        
        return credential
    }
    
    private func storeCredentialData(_ data: Data) {
        let loginCredentialQuery = makeMutableLoginCredentialQuery()
        loginCredentialQuery.setObject(data, forKey: kSecValueData as NSString)
        
        SecItemAdd(loginCredentialQuery, nil)
    }
    
    private struct KeychainItemAttributes: Codable {
        
        var username: String
        var authenticationToken: String
        var registrationNumber: Int
        var tokenExpiryDate: Date
        
        var credential: Credential {
            return Credential(username: username,
                              registrationNumber: registrationNumber,
                              authenticationToken: authenticationToken,
                              tokenExpiryDate: tokenExpiryDate)
        }
        
        static func fromCredential(_ credential: Credential) -> KeychainItemAttributes {
            return KeychainItemAttributes(username: credential.username,
                                          authenticationToken: credential.authenticationToken,
                                          registrationNumber: credential.registrationNumber,
                                          tokenExpiryDate: credential.tokenExpiryDate)
        }
        
    }
    
}