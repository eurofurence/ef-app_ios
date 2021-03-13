import EurofurenceApplication
import EurofurenceModel
import Foundation

class CapturingDealerDetailViewModelVisitor: DealerDetailViewModelVisitor {
    
    private(set) var visitedComponents = [Any]()

    private(set) var visitedSummary: DealerDetailSummaryViewModel?
    func visit(_ summary: DealerDetailSummaryViewModel) {
        visitedSummary = summary
        visitedComponents.append(summary)
    }

    private(set) var visitedLocationAndAvailability: DealerDetailLocationAndAvailabilityViewModel?
    func visit(_ location: DealerDetailLocationAndAvailabilityViewModel) {
        visitedLocationAndAvailability = location
        visitedComponents.append(location)
    }

    private(set) var visitedAboutTheArtist: DealerDetailAboutTheArtistViewModel?
    func visit(_ aboutTheArtist: DealerDetailAboutTheArtistViewModel) {
        visitedAboutTheArtist = aboutTheArtist
        visitedComponents.append(aboutTheArtist)
    }

    private(set) var visitedAboutTheArt: DealerDetailAboutTheArtViewModel?
    func visit(_ aboutTheArt: DealerDetailAboutTheArtViewModel) {
        visitedAboutTheArt = aboutTheArt
        visitedComponents.append(aboutTheArt)
    }

}
