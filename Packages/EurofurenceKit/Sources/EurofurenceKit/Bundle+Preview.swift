import Foundation

extension Bundle {
    
    private class BundleScope { }
    
    /// Workaround to access an appropriate `Bundle` for resolving resources within a SwiftUI canvas.
    static var previewing: Bundle {
        let cocoaTouchBundleName = "LocalPackages_EurofurenceKit"
        let cocoaBundleName = "EurofurenceKit_EurofurenceKit"
        
        let appLinkedBundleURL = Bundle.main.resourceURL
        let commandLineBundleURL = Bundle.main.bundleURL
        let frameworkLinkedBundleURL = Bundle(for: BundleScope.self).resourceURL
        let uiTestingBundleURL = frameworkLinkedBundleURL?.deletingLastPathComponent()
        let crossPackagePreviewBundleURL = frameworkLinkedBundleURL?
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        
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
        
        fatalError("No EurofurenceKit bundle found")
    }
    
}
