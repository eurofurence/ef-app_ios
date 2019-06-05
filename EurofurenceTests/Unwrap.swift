import Foundation

// Temporary addition until Xcode 11's XCTUnwrap is available for us to use.
func unwrap<T>(_ value: @autoclosure () -> T?) -> T {
    guard let unwrapped = value() else {
        fatalError("This should not produce a nil value - has some configuration changed?")
    }
    
    return unwrapped
}
