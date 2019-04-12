@testable import Eurofurence
import EurofurenceModel
import Foundation

class CapturingDealerDetailViewModelVisitor: DealerDetailViewModelVisitor {

    private(set) var visitedSummary: DealerDetailSummaryViewModel?
    func visit(_ summary: DealerDetailSummaryViewModel) {
        visitedSummary = summary
    }

    private(set) var visitedLocationAndAvailability: DealerDetailLocationAndAvailabilityViewModel?
    func visit(_ location: DealerDetailLocationAndAvailabilityViewModel) {
        visitedLocationAndAvailability = location
    }

    private(set) var visitedAboutTheArtist: DealerDetailAboutTheArtistViewModel?
    func visit(_ aboutTheArtist: DealerDetailAboutTheArtistViewModel) {
        visitedAboutTheArtist = aboutTheArtist
    }

    private(set) var visitedAboutTheArt: DealerDetailAboutTheArtViewModel?
    func visit(_ aboutTheArt: DealerDetailAboutTheArtViewModel) {
        visitedAboutTheArt = aboutTheArt
    }

}
