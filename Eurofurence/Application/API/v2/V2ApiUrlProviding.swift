//
//  V2ApiUrlProviding.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 19/06/18.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol V2ApiUrlProviding {

    var url: String { get }

}

class BuildConfigurationV2ApiUrlProviding: V2ApiUrlProviding {

    let url: String

    init(_ buildConfiguration: BuildConfigurationProviding) {
        switch (buildConfiguration.configuration) {
        case .debug:
            url = "https://app.eurofurence.org:40000/api/v2/"
        case .release:
            url = "https://app.eurofurence.org/api/v2/"
        }
    }
}
