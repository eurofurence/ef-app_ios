import EurofurenceModel
import Foundation.NSAttributedString

struct DefaultAnnouncementDetailInteractor: AnnouncementDetailInteractor {

    private let announcementsService: AnnouncementsService
    private let markdownRenderer: MarkdownRenderer

    init() {
        self.init(announcementsService: SharedModel.instance.services.announcements,
                  markdownRenderer: DefaultDownMarkdownRenderer())
    }

    init(announcementsService: AnnouncementsService, markdownRenderer: MarkdownRenderer) {
        self.announcementsService = announcementsService
        self.markdownRenderer = markdownRenderer
    }

    func makeViewModel(for identifier: AnnouncementIdentifier, completionHandler: @escaping (AnnouncementViewModel) -> Void) {
        guard let announcement = announcementsService.fetchAnnouncement(identifier: identifier) else { return }
        
        announcement.fetchAnnouncementImagePNGData { (imageData) in
            let contents = self.markdownRenderer.render(announcement.content)
            let viewModel = AnnouncementViewModel(heading: announcement.title, contents: contents, imagePNGData: imageData)
            completionHandler(viewModel)
        }
    }

}
