import EurofurenceApplication
import EurofurenceModel
import Foundation

class FakeDealerDetailViewModel: DealerDetailViewModel {

    init(numberOfComponents: Int) {
        self.numberOfComponents = numberOfComponents
    }

    var numberOfComponents: Int

    func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) { }

    private(set) var toldToOpenWebsite = false
    func openWebsite() {
        toldToOpenWebsite = true
    }

    private(set) var toldToOpenTwitter = false
    func openTwitter() {
        toldToOpenTwitter = true
    }

    private(set) var toldToOpenTelegram = false
    func openTelegram() {
        toldToOpenTelegram = true
    }
    
    private(set) var shareCommandSender: Any?
    func shareDealer(_ sender: Any) {
        shareCommandSender = sender
    }

}

class FakeDealerDetailSummaryViewModel: FakeDealerDetailViewModel {

    private let summary: DealerDetailSummaryViewModel

    init(summary: DealerDetailSummaryViewModel) {
        self.summary = summary
        super.init(numberOfComponents: 1)
    }

    override func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) {
        visitor.visit(summary)
    }

}

class FakeDealerDetailLocationAndAvailabilityViewModel: FakeDealerDetailViewModel {

    private let location: DealerDetailLocationAndAvailabilityViewModel

    init(location: DealerDetailLocationAndAvailabilityViewModel) {
        self.location = location
        super.init(numberOfComponents: 1)
    }

    override func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) {
        visitor.visit(location)
    }

}

class FakeDealerDetailAboutTheArtistViewModel: FakeDealerDetailViewModel {

    private let aboutTheArtist: DealerDetailAboutTheArtistViewModel

    init(aboutTheArtist: DealerDetailAboutTheArtistViewModel) {
        self.aboutTheArtist = aboutTheArtist
        super.init(numberOfComponents: 1)
    }

    override func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) {
        visitor.visit(aboutTheArtist)
    }

}

class FakeDealerDetailAboutTheArtViewModel: FakeDealerDetailViewModel {

    private let aboutTheArt: DealerDetailAboutTheArtViewModel

    init(aboutTheArt: DealerDetailAboutTheArtViewModel) {
        self.aboutTheArt = aboutTheArt
        super.init(numberOfComponents: 1)
    }

    override func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) {
        visitor.visit(aboutTheArt)
    }

}
