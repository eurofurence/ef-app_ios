import EurofurenceApplicationSession

public struct StubBuildConfigurationProviding: BuildConfigurationProviding {

    public var configuration: BuildConfiguration

    public init(configuration: BuildConfiguration) {
        self.configuration = configuration
    }

}
