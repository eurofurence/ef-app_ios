import EurofurenceWebAPI
import Foundation
import Logging
import Security

public class SecKeychain: Keychain {
    
    public static let shared = SecKeychain()
    private let logger = Logger(label: "Keychain")
    private let userAccount: String = "Eurofurence"
    
    private init() {
        
    }
    
    public var credential: Credential? {
        get {
            var item: CFTypeRef?
            SecItemCopyMatching(makeMutableLoginCredentialQuery(), &item)
            
            return parseCredentialFromKeychainItem(item)
        }
        set {
            // The keychain API needs the previous value for the query to be clear before
            // updating it, otherwise it pollutes the new value. In our case this makes the
            // stored credential data garbage and can't be decoded.
            deletePersistedToken()
            
            if let credential = newValue {
                store(credential: credential)
            }
        }
    }
    
    private func deletePersistedToken() {
        logger.info("Clearing persistent token from Keychain")
        SecItemDelete(makeMutableLoginCredentialQuery())
    }
    
    private func store(credential: Credential) {
        let keychainItem = KeychainItemAttributes.fromCredential(credential)
        
        let encoder = JSONEncoder()
        
        do {
            let keychainItemData = try encoder.encode(keychainItem)
            storeCredentialData(keychainItemData)
        } catch {
            logger.error("Failed to store login credential.", metadata: ["Error": .string(String(describing: error))])
        }
        
    }
    
    private func makeMutableLoginCredentialQuery() -> NSMutableDictionary {
        NSMutableDictionary(dictionary: [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: userAccount,
            kSecReturnData: kCFBooleanTrue as Any
        ])
    }
    
    private func copyItemFromKeychain() -> CFTypeRef? {
        var item: CFTypeRef?
        SecItemCopyMatching(makeMutableLoginCredentialQuery(), &item)
        
        return item
    }
    
    private func parseCredentialFromKeychainItem(_ item: CFTypeRef?) -> Credential? {
        var credential: Credential?
        if let data = item as? NSData {
            let decoder = JSONDecoder()
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
            Credential(
                username: username,
                registrationNumber: registrationNumber,
                authenticationToken: AuthenticationToken(authenticationToken),
                tokenExpiryDate: tokenExpiryDate
            )
        }
        
        static func fromCredential(_ credential: Credential) -> KeychainItemAttributes {
            KeychainItemAttributes(
                username: credential.username,
                authenticationToken: credential.authenticationToken.rawValue,
                registrationNumber: credential.registrationNumber,
                tokenExpiryDate: credential.tokenExpiryDate
            )
        }
        
    }
    
}
