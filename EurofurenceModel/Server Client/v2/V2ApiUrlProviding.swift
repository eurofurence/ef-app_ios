//
//  V2ApiUrlProviding.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 19/06/18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

public protocol V2ApiUrlProviding {

    var url: String { get }

}

public struct BuildConfigurationV2ApiUrlProviding: V2ApiUrlProviding {

    public let url: String

    public init(_ buildConfiguration: BuildConfigurationProviding) {
        self.init(buildConfiguration,
                  debugUrl: "https://app.eurofurence.org/api/v2/",
                  releaseUrl: "https://app.eurofurence.org/api/v2/")
    }

    public init(_ buildConfiguration: BuildConfigurationProviding, debugUrl: String, releaseUrl: String) {
        switch (buildConfiguration.configuration) {
        case .debug:
            url = debugUrl
        case .release:
            url = releaseUrl
        }
    }
}
