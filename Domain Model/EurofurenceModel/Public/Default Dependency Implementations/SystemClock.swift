import Foundation

public class SystemClock: Clock {

    public static let shared = SystemClock()
    private var timer: Timer?

    private init() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: timerFired)
    }

    public var currentDate: Date {
        let components = DateComponents(calendar: .current, timeZone: .current, year: 2019, month: 8, day: 15, hour: 14)
        return Calendar.current.date(from: components)!
    }

    private var delegate: ClockDelegate?
    public func setDelegate(_ delegate: ClockDelegate) {
        self.delegate = delegate
    }

    private func timerFired(_ timer: Timer) {
        delegate?.clockDidTick(to: currentDate)
    }

}
