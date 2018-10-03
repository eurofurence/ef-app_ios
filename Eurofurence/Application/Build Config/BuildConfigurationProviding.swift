//
//  BuildConfigurationProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

public enum BuildConfiguration {
    case debug
    case release
}

public protocol BuildConfigurationProviding {

    var configuration: BuildConfiguration { get }

}

public struct PreprocessorBuildConfigurationProviding: BuildConfigurationProviding {

    public var configuration: BuildConfiguration {
#if DEBUG
            return .debug
#else
            return .release
#endif
    }

}
