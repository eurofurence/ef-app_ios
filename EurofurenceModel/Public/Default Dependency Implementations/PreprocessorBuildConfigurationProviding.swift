import Foundation

public struct PreprocessorBuildConfigurationProviding: BuildConfigurationProviding {

    public init() {

    }

    public var configuration: BuildConfiguration {
#if DEBUG
        return .debug
#else
        return .release
#endif
    }

}
