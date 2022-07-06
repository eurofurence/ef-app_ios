import Foundation

struct TestResources {
    
    private static func loadResource(fileName: String, fileExtension: String) throws -> Data {
        class BundleScope { }
        
        struct MissingResourceError: Error {
            var fileName: String
            var fileExtension: String
        }
        
        let bundle = Bundle(for: BundleScope.self)
        guard let testAccountCredentialsFileURL = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            throw MissingResourceError(fileName: fileName, fileExtension: fileExtension)
        }
        
        return try Data(contentsOf: testAccountCredentialsFileURL)
    }
    
}

// MARK: - Credentials

extension TestResources {
    
    struct Credentials: Decodable {
        var username: String
        var password: String
        var registrationNumber: String
    }
    
    static func loadTestCredentials() throws -> Credentials {
        let data = try loadResource(fileName: "TestAccountCredentials", fileExtension: "plist")
        let decoder = PropertyListDecoder()
        
        return try decoder.decode(Credentials.self, from: data)
    }
    
}
