import EurofurenceWebAPI
import Foundation

public class AppGroupModelProperties: EurofurenceModelProperties {
    
    public static let shared = AppGroupModelProperties()
    private let userDefaults: UserDefaults
    
    convenience init() {
        guard let appGroupUserDefaults = UserDefaults(suiteName: SecurityGroup.identifier) else {
            fatalError("Cannot instantiate App Group user defaults")
        }
        
        self.init(userDefaults: appGroupUserDefaults)
        
        // Make sure the container directory and subdirectories exist.
        let fileManager = FileManager.default
        var unused: ObjCBool = false
        if fileManager.fileExists(atPath: imagesDirectory.path, isDirectory: &unused) == false {
            do {
                try fileManager.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
            } catch {
                print("Failed to prepare images directory!")
            }
        }
    }
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    private struct Keys {
        static let synchronizationGenerationTokenData = "EFKSynchronizationGenerationTokenData"
    }
    
    public var containerDirectoryURL: URL {
        let fileManager = FileManager.default
        guard let url = fileManager.containerURL(forSecurityApplicationGroupIdentifier: SecurityGroup.identifier) else {
            fatalError("Couldn't resolve URL for shared container")
        }

        return url
    }
    
    public var synchronizationChangeToken: SynchronizationPayload.GenerationToken? {
        get {
            guard let data = userDefaults.data(forKey: Keys.synchronizationGenerationTokenData) else { return nil }
            
            let decoder = JSONDecoder()
            return try? decoder.decode(SynchronizationPayload.GenerationToken.self, from: data)
        }
        set {
            if let newValue = newValue {
                let encoder = JSONEncoder()
                guard let data = try? encoder.encode(newValue) else { return }
                
                userDefaults.set(data, forKey: Keys.synchronizationGenerationTokenData)
            } else {
                userDefaults.set(nil, forKey: Keys.synchronizationGenerationTokenData)
            }
        }
    }
    
    public func removeContainerResource(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }
    
}
