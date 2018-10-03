//
//  BuildConfigurationV2ApiUrlProviding.swift
//  EurofurenceTests
//
//  Created by Dominik Schöner on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Eurofurence
import XCTest

class BuildConfigurationV2ApiUrlProvidingTest: XCTestCase {
    let debugUrl = "https://debug.api.example.com/v2/"
    let releaseUrl = "https://api.example.com/v2/"
    
    func testTheProviderShouldReturnTheDebugUrlForBuildConfigurationDebug() {
        let expectedUrl = debugUrl
        let buildConfiguration = StubBuildConfigurationProviding(configuration: .debug)
        
        let provider = BuildConfigurationV2ApiUrlProviding(buildConfiguration,
                                                           debugUrl: debugUrl,
                                                           releaseUrl: releaseUrl)
        XCTAssertEqual(expectedUrl, provider.url)
    }
    
    func testTheProviderShouldReturnTheReleaseUrlForBuildConfigurationRelease() {
        let expectedUrl = releaseUrl
        let buildConfiguration = StubBuildConfigurationProviding(configuration: .release)
        
        let provider = BuildConfigurationV2ApiUrlProviding(buildConfiguration,
                                                           debugUrl: debugUrl,
                                                           releaseUrl: releaseUrl)
        XCTAssertEqual(expectedUrl, provider.url)
    }
}
