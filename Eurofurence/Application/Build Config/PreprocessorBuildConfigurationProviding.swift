//
//  PreprocessorBuildConfigurationProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct PreprocessorBuildConfigurationProviding: BuildConfigurationProviding {

    var configuration: BuildConfiguration {
#if DEBUG
        return .debug
#else
        return .release
#endif
    }

}
