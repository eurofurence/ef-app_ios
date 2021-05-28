import ComponentBase
import Foundation
import URLContent

public struct UserActivityContentRepresentation: ContentRepresentation {
    
    private let descriptor: Descriptor
    
    public init(activity: ActivityDescription) {
        let unwrapper = UnwrapDescriptionFromActivity()
        activity.describe(to: unwrapper)
        descriptor = unwrapper.unwrapped
    }
    
}

// MARK: - ContentRepresentationDescribing

extension UserActivityContentRepresentation: ContentRepresentationDescribing {
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        descriptor.describe(to: recipient)
    }
    
    private class UnwrapDescriptionFromActivity: ActivityDescriptionVisitor {
        
        private(set) var unwrapped: Descriptor = Descriptor()
        
        func visitIntent(_ intent: AnyHashable) {
            unwrapped = IntentDescriptor(intent: intent)
        }
        
        func visitURL(_ url: URL) {
            unwrapped = URLDescriptor(url: url)
        }
        
    }
    
    private class Descriptor: Equatable {
        
        static func == (lhs: Descriptor, rhs: Descriptor) -> Bool {
            lhs === rhs
        }
        
        func describe(to recipient: ContentRepresentationRecipient) {
            
        }
        
    }
    
    private class IntentDescriptor: Descriptor {
        
        private let content: IntentContentRepresentation
        
        init(intent: AnyHashable) {
            content = IntentContentRepresentation(intent: intent)
        }
        
        override func describe(to recipient: ContentRepresentationRecipient) {
            recipient.receive(content)
        }
        
    }
    
    private class URLDescriptor: Descriptor {
        
        private let content: URLContentRepresentation
        
        init(url: URL) {
            content = URLContentRepresentation(url: url)
        }
        
        override func describe(to recipient: ContentRepresentationRecipient) {
            recipient.receive(content)
        }
        
    }
    
}
