import Combine
import Foundation
import ObservedObject
import RouterCore

public class DataSourceBackedYourEurofurenceWidgetViewModel: YourEurofurenceWidgetViewModel {
    
    private static let regNumberFormatter = NumberFormatter()
    private let router: Router
    
    @Observed public private(set) var prompt: String = .anonymousUserLoginPrompt
    @Observed public private(set) var supplementaryPrompt: String = .anonymousUserLoginDescription
    @Observed public private(set) var isHighlightedForAttention: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    init<DataSource>(dataSource: DataSource, router: Router) where DataSource: YourEurofurenceDataSource {
        self.router = router
        
        dataSource
            .state
            .sink { [weak self] (state) in
                self?.update(from: state)
            }
            .store(in: &subscriptions)
    }
    
    public func showPersonalisedContent() {
        try? router.route(MessagesRouteable())
    }
    
    private func update(from state: AuthenticatedUserSummary?) {
        if let state = state {
            applyPersonalisedInformation(state)
        } else {
            applyAnonymousTemplate()
        }
    }
    
    private func applyAnonymousTemplate() {
        prompt = .anonymousUserLoginPrompt
        supplementaryPrompt = .anonymousUserLoginDescription
        isHighlightedForAttention = false
    }
    
    private func applyPersonalisedInformation(_ user: AuthenticatedUserSummary) {
        if let formattedRegNumber = Self.regNumberFormatter.string(from: NSNumber(value: user.regNumber)) {
            let promptFormat = String.authenticatedUserLoginPromptFormat
            
            prompt = String.localizedStringWithFormat(
                promptFormat,
                user.username,
                formattedRegNumber
            )
        }
        
        let supplementaryPromptFormat = String.authentiatedUserLoginDescriptionFormat
        supplementaryPrompt = String.localizedStringWithFormat(
            supplementaryPromptFormat,
            user.unreadMessageCount
        )
        
        isHighlightedForAttention = user.unreadMessageCount > 0
    }
    
}
