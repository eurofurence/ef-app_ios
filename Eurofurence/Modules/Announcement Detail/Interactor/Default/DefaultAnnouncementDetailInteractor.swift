import EurofurenceModel
import Foundation.NSAttributedString

struct DefaultAnnouncementDetailInteractor: AnnouncementDetailInteractor {

    var announcementsService: AnnouncementsService
    var markdownRenderer: MarkdownRenderer

    func makeViewModel(for identifier: AnnouncementIdentifier, completionHandler: @escaping (AnnouncementViewModel) -> Void) {
        guard let announcement = announcementsService.fetchAnnouncement(identifier: identifier) else { return }
        
        announcement.fetchAnnouncementImagePNGData { (imageData) in
            let contents = self.markdownRenderer.render(announcement.content)
            let viewModel = AnnouncementViewModel(heading: announcement.title, contents: contents, imagePNGData: imageData)
            completionHandler(viewModel)
        }
    }

}
