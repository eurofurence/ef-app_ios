//
//  DealerDetailViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealerDetailViewModel {

    var numberOfComponents: Int { get }
    func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor)

}

protocol DealerDetailViewModelVisitor {

    func visit(_ summary: DealerDetailSummaryViewModel)

}

struct DealerDetailSummaryViewModel: Hashable {

    var artistImagePNGData: Data

}
