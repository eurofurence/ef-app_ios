//
//  NewsViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

extension NewsViewModel: RandomValueProviding {
    
    static var random: NewsViewModel {
        return NewsViewModel(components: .random)
    }
    
}

extension NewsViewModel.Component: RandomValueProviding {
    
    static var random: NewsViewModel.Component {
        return NewsViewModel.Component(title: .random, numberOfItems: .random)
    }
    
}
