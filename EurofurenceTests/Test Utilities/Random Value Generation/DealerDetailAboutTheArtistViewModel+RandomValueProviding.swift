//
//  DealerDetailAboutTheArtistViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension DealerDetailAboutTheArtistViewModel: RandomValueProviding {

    public static var random: DealerDetailAboutTheArtistViewModel {
        return DealerDetailAboutTheArtistViewModel(title: .random, artistDescription: .random)
    }

}
