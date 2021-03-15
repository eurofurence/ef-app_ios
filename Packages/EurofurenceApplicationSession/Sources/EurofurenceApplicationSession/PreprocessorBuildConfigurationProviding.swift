struct PreprocessorBuildConfigurationProviding: BuildConfigurationProviding {

    var configuration: BuildConfiguration {
#if DEBUG
        return .debug
#else
        return .release
#endif
    }

}
