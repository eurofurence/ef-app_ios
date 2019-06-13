import Foundation

public struct BundleAppVersionProviding: AppVersionProviding {

    public static let shared = BundleAppVersionProviding()

    public var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

}
