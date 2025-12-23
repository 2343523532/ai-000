import Foundation

public extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double { min(max(self, range.lowerBound), range.upperBound) }
}

public extension Date {
    func iso8601() -> String { ISO8601DateFormatter().string(from: self) }
}

public extension Array {
    func safeIndex(_ i: Int) -> Element? { (i >= 0 && i < count) ? self[i] : nil }
}

public func now() -> Date { Date() }
