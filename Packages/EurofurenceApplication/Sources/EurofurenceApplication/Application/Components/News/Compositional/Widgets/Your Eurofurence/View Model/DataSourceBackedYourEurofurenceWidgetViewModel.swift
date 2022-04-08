import Combine
import Foundation
import ObservedObject

public class DataSourceBackedYourEurofurenceWidgetViewModel: YourEurofurenceWidgetViewModel {
    
    private static let regNumberFormatter = NumberFormatter()
    
    @Observed public private(set) var prompt: String = .anonymousUserLoginPrompt
    @Observed public private(set) var supplementaryPrompt: String = .anonymousUserLoginDescription
    @Observed public private(set) var isHighlightedForAttention: Bool = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init<DataSource>(dataSource: DataSource) where DataSource: YourEurofurenceDataSource {
        dataSource
            .state
            .sink { [weak self] (state) in
                self?.update(from: state)
            }
            .store(in: &subscriptions)
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
