@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class AnnouncementDetailViewModelFactoryTestBuilder {

    struct Context {
        var viewModelFactory: AnnouncementDetailViewModelFactory
        var markdownRenderer: StubMarkdownRenderer
        var announcement: StubAnnouncement
        var announcementsService: FakeAnnouncementsService
    }
    
    private var imagePNGData: Data?
    
    func with(imagePNGData: Data) -> AnnouncementDetailViewModelFactoryTestBuilder {
        self.imagePNGData = imagePNGData
        return self
    }

    func build(for identifier: AnnouncementIdentifier = .random) -> Context {
        let announcement = StubAnnouncement.random
        announcement.identifier = identifier
        announcement.imagePNGData = imagePNGData
        let announcementsService = FakeAnnouncementsService(announcements: [announcement])
        let markdownRenderer = StubMarkdownRenderer()
        let viewModelFactory = DefaultAnnouncementDetailViewModelFactory(announcementsService: announcementsService,
                                                             markdownRenderer: markdownRenderer)

        return Context(viewModelFactory: viewModelFactory,
                       markdownRenderer: markdownRenderer,
                       announcement: announcement,
                       announcementsService: announcementsService)
    }
    
    func buildForMissingAnnouncement() -> Context {
        let announcementsService = FakeAnnouncementsService(announcements: [])
        let markdownRenderer = StubMarkdownRenderer()
        let viewModelFactory = DefaultAnnouncementDetailViewModelFactory(announcementsService: announcementsService,
                                                             markdownRenderer: markdownRenderer)

        return Context(viewModelFactory: viewModelFactory,
                       markdownRenderer: markdownRenderer,
                       announcement: .random,
                       announcementsService: announcementsService)
    }

}

extension AnnouncementDetailViewModelFactoryTestBuilder.Context {

    func makeViewModel() -> AnnouncementDetailViewModel? {
        var viewModel: AnnouncementDetailViewModel?
        viewModelFactory.makeViewModel(for: announcement.identifier) { viewModel = $0 }

        return viewModel
    }

}
