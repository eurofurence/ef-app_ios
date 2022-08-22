import EventKit
import EventKitUI
import UIKit

public class EventKitEventStore: NSObject, EventStore {
    
    private let window: UIWindow
    private let eventStore: EKEventStore
    
    public init(window: UIWindow) {
        self.window = window
        self.eventStore = EKEventStore()
    }
    
    public func editEvent(definition event: EventStoreEventDefinition, sender: Any?) {
        attemptCalendarStoreEdit { [eventStore, window] in
            let calendarEvent = EKEvent(eventStore: eventStore)
            calendarEvent.title = event.title
            calendarEvent.startDate = event.startDate
            calendarEvent.endDate = event.endDate
            calendarEvent.url = event.deeplinkURL
            
            let editingViewController = EKEventEditViewController()
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
            
            window.rootViewController?.present(editingViewController, animated: true)
        }
    }
    
    public func removeEvent(identifiedBy identifier: String) {
        attemptCalendarStoreEdit { [eventStore] in
            if let event = eventStore.event(withIdentifier: identifier) {
                do {
                    try eventStore.remove(event, span: .thisEvent)
                } catch {
                    print("Failed to remove event \(identifier) from calendar. Error=\(error)")
                }
            }
        }
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
            if granted {
                success()
            } else {
                self?.presentNotAuthorizedAlert()
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
