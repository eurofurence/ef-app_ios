public enum BuildConfiguration {
    case debug
    case release
}

public protocol BuildConfigurationProviding {

    var configuration: BuildConfiguration { get }

}
