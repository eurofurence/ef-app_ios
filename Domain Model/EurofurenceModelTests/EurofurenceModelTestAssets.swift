import Foundation

class EurofurenceModelTestAssets {
    
    class var successfulSyncResponseData: Data {
        return loadContentsOfFile(named: "V2SyncAPIResponse", extension: "json")
    }
    
    private class func loadContentsOfFile(named fileName: String, extension ext: String) -> Data {
        let bundle = Bundle(for: EurofurenceModelTestAssets.self)
        guard let url = bundle.url(forResource: fileName, withExtension: ext) else {
            fatalError("\(fileName).\(ext) missing from test bundle")
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Unable to read contents of \(url)")
        }
    }
    
}
