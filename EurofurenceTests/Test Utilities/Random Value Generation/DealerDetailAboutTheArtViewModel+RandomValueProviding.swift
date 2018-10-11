//
//  DealerDetailAboutTheArtViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import RandomDataGeneration

extension DealerDetailAboutTheArtViewModel: RandomValueProviding {

    public static var random: DealerDetailAboutTheArtViewModel {
        return DealerDetailAboutTheArtViewModel(title: .random,
                                                aboutTheArt: .random,
                                                artPreviewImagePNGData: .random,
                                                artPreviewCaption: .random)
    }

}
