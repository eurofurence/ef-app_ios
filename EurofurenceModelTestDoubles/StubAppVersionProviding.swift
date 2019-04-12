import EurofurenceModel
import Foundation

public struct StubAppVersionProviding: AppVersionProviding {

    public var version: String

    public init(version: String) {
        self.version = version
    }

}
