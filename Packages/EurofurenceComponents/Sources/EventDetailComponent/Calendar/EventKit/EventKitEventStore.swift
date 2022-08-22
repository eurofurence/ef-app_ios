import EventKit
import EventKitUI
import UIKit

public class EventKitEventStore: NSObject, EventStore {
    
    private let window: UIWindow
    private let eventStore: EKEventStore
    private var currentEditingCompletionHandler: ((Bool) -> Void)?
    
    public init(window: UIWindow) {
        self.window = window
        self.eventStore = EKEventStore()
    }
    
    public func editEvent(
        definition event: EventStoreEventDefinition,
        sender: Any?,
        completionHandler: @escaping (Bool) -> Void
    ) {
        attemptCalendarStoreEdit { [weak self, eventStore] in
            self?.currentEditingCompletionHandler = completionHandler
            
            let calendarEvent = EKEvent(eventStore: eventStore)
            calendarEvent.title = event.title
            calendarEvent.location = event.room
            calendarEvent.startDate = event.startDate
            calendarEvent.endDate = event.endDate
            calendarEvent.url = event.deeplinkURL
            
            let editingViewController = EKEventEditViewController()
            editingViewController.editViewDelegate = self
            editingViewController.eventStore = eventStore
            editingViewController.event = calendarEvent
            
            switch sender {
            case let sender as UIBarButtonItem:
                editingViewController.popoverPresentationController?.barButtonItem = sender
                
            case let sender as UIView:
                editingViewController.popoverPresentationController?.sourceView = sender
                editingViewController.popoverPresentationController?.sourceRect = sender.bounds
                
            default:
                break
            }
            
            self?.window.rootViewController?.present(editingViewController, animated: true)
        }
    }
    
    public func removeEvent(identifiedBy eventDefinition: EventStoreEventDefinition) {
        attemptCalendarStoreEdit { [weak self] in
            if let event = self?.storeEvent(for: eventDefinition) {
                do {
                    try self?.eventStore.remove(event, span: .thisEvent)
                } catch {
                    print("Failed to remove event \(eventDefinition) from calendar. Error=\(error)")
                }
            }
        }
    }
    
    public func contains(eventDefinition: EventStoreEventDefinition) -> Bool {
        return storeEvent(for: eventDefinition) != nil
    }
    
    private func storeEvent(for eventDefinition: EventStoreEventDefinition) -> EKEvent? {
        let predicate = eventStore.predicateForEvents(
            withStart: eventDefinition.startDate,
            end: eventDefinition.endDate,
            calendars: nil
        )
        
        let events = eventStore.events(matching: predicate)
        return events.first(where: { $0.url == eventDefinition.deeplinkURL })
    }
    
    private func attemptCalendarStoreEdit(edit: @escaping () -> Void) {
        if EKEventStore.authorizationStatus(for: .event) == .authorized {
            edit()
        } else {
            requestCalendarEditingAuthorisation(success: edit)
        }
    }
    
    private func requestCalendarEditingAuthorisation(success: @escaping () -> Void) {
        eventStore.requestAccess(to: .event) { [weak self] granted, _ in
            DispatchQueue.main.async {
                if granted {
                    success()
                } else {
                    self?.presentNotAuthorizedAlert()
                }
            }
        }
    }
    
    private func presentNotAuthorizedAlert() {
        let alert = UIAlertController(
            title: "Not Authorised",
            message: "Grant Calendar access to Eurofurence in Settings to add events to Calendar.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        window.rootViewController?.present(alert, animated: true)
    }
    
}

extension EventKitEventStore: EKEventEditViewDelegate {
    
    public func eventEditViewController(
        _ controller: EKEventEditViewController,
        didCompleteWith action: EKEventEditViewAction
    ) {
        currentEditingCompletionHandler?(action == .saved)
        currentEditingCompletionHandler = nil
        
        controller.presentingViewController?.dismiss(animated: true)
    }
    
}
