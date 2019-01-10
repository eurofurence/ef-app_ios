//
//  PreprocessorBuildConfigurationProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/12/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

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
