//
//  NewsViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import RandomDataGeneration

extension StubNewsViewModel: RandomValueProviding {

    public static var random: StubNewsViewModel {
        return StubNewsViewModel(components: .random)
    }

}

extension StubNewsViewModel.Component: RandomValueProviding {

    public static var random: StubNewsViewModel.Component {
        return StubNewsViewModel.Component(title: .random, numberOfItems: .random)
    }

}
