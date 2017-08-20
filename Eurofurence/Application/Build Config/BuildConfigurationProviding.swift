//
//  BuildConfigurationProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

enum BuildConfiguration {
    case debug
    case release
}

protocol BuildConfigurationProviding {

    var configuration: BuildConfiguration { get }

}

struct PreprocessorBuildConfigurationProviding: BuildConfigurationProviding {

    var configuration: BuildConfiguration {
#if DEBUG
            return .debug
#else
            return .release
#endif
    }

}
