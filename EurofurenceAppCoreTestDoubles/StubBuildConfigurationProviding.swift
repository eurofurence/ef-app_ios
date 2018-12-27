//
//  StubBuildConfigurationProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel

public struct StubBuildConfigurationProviding: BuildConfigurationProviding {

    public var configuration: BuildConfiguration

    public init(configuration: BuildConfiguration) {
        self.configuration = configuration
    }

}
