import Combine
import SwiftUI

/// Defines an overlay view to be presented on top of the view hiearchy in a transient presentation style, e.g. passive
/// alerts.
class TransientOverlay: Equatable, Identifiable, ObservableObject {
    
    static func == (lhs: TransientOverlay, rhs: TransientOverlay) -> Bool {
        lhs.id == rhs.id
    }
    
    private let overlay: (Namespace.ID) -> AnyView
    private let transiency: TransiencyInterval
    private var subscriptions = Set<AnyCancellable>()
    
    init<ID, Overlay>(
        id: ID,
        isPresented: Bool,
        transiency: TransiencyInterval,
        overlay: @escaping (Namespace.ID) -> Overlay
    ) where ID: Hashable, Overlay: View {
        self.id = AnyHashable(id)
        self.isPresented = isPresented
        self.transiency = transiency
        self.overlay = { namespace in AnyView(overlay(namespace)) }
    }
    
    /// A stable identity for the overlay, typically sourced from a model object.
    let id: AnyHashable
    
    /// Designates whether this overlay is presented.
    @Published var isPresented: Bool
    
    /// Prepares the `View` to be rendered within the overlay described by the receiver.
    /// 
    /// - Parameter presentationNamespace: A `Namespace` in which presentation transitions will occur.
    /// - Returns: A type-erased `View` to present atop over views.
    func makeOverlay(presentationNamespace: Namespace.ID) -> AnyView {
        overlay(presentationNamespace)
    }
    
    /// Notifies the receiver the corresponding overlay has been presented.
    func onAppear() {
        registerAutomaticalDismissalHandler()
    }
    
    private func registerAutomaticalDismissalHandler() {
        autoDismissPublisher
            .prefix(1)
            .sink { [weak self] _ in
                self?.autoDismiss()
            }
            .store(in: &subscriptions)
    }
    
    /// A `Publisher` that will emit an event once when the overlay should be dismissed.
    private var autoDismissPublisher: AnyPublisher<Void, Never> {
        switch transiency {
        case .indefinite:
            return PassthroughSubject<Void, Never>()
                .eraseToAnyPublisher()
            
        case .brief(let seconds):
            return Timer.publish(every: seconds, on: .main, in: .common)
                .autoconnect()
                .flatMap(maxPublishers: .max(1)) { publisher in
                    Just(())
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func autoDismiss() {
        withAnimation(.spring()) {
            isPresented = false
        }
    }
    
}
