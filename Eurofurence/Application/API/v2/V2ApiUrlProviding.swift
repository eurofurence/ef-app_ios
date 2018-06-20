//
//  V2ApiUrlProviding.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 19/06/18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol V2ApiUrlProviding {

    var url: String { get }

}

struct BuildConfigurationV2ApiUrlProviding: V2ApiUrlProviding {

    let url: String

    init(_ buildConfiguration: BuildConfigurationProviding) {
        self.init(buildConfiguration,
                  debugUrl: "https://app.eurofurence.org:40000/api/v2/",
                  releaseUrl: "https://app.eurofurence.org/api/v2/")
    }

    init(_ buildConfiguration: BuildConfigurationProviding, debugUrl: String, releaseUrl: String) {
        switch (buildConfiguration.configuration) {
        case .debug:
            url = debugUrl
        case .release:
            url = releaseUrl
        }
    }
}
