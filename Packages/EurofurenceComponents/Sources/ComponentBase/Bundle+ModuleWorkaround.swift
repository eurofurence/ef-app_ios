import Foundation

extension Bundle {
    
    private class BundleScope { }
    
    static var moduleWorkaround: Bundle {
        let cocoaTouchBundleName = "LocalPackages_ComponentBase"
        let cocoaBundleName = "EurofurenceComponents_ComponentBase"
        
        let appLinkedBundleURL = Bundle.main.resourceURL
        let commandLineBundleURL = Bundle.main.bundleURL
        let frameworkLinkedBundleURL = Bundle(for: BundleScope.self).resourceURL
        let uiTestingBundleURL = frameworkLinkedBundleURL?.deletingLastPathComponent()
        let crossPackagePreviewBundleURL = frameworkLinkedBundleURL?.deletingLastPathComponent().deletingLastPathComponent()
        
        let candidates = [
            appLinkedBundleURL,
            commandLineBundleURL,
            frameworkLinkedBundleURL,
            uiTestingBundleURL,
            crossPackagePreviewBundleURL
        ]
        .compactMap { $0 }
        
        let bundlePaths = candidates.flatMap { (candidate) in
            return [
                candidate.appendingPathComponent("\(cocoaTouchBundleName).bundle"),
                candidate.appendingPathComponent("\(cocoaBundleName).bundle")
            ]
        }
        
        let bundle = bundlePaths
            .lazy
            .compactMap(Bundle.init(url:))
            .first
        
        if let bundle = bundle {
            return bundle
        }
        
        fatalError("No ComponentBase bundle found")
    }
    
}
