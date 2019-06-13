import Foundation

public class SystemClock: Clock {

    public static let shared = SystemClock()
    private var timer: Timer?

    private init() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: timerFired)
    }

    public var currentDate: Date {
        return Date()
    }

    private var delegate: ClockDelegate?
    public func setDelegate(_ delegate: ClockDelegate) {
        self.delegate = delegate
    }

    private func timerFired(_ timer: Timer) {
        delegate?.clockDidTick(to: currentDate)
    }

}
