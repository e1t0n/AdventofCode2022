import Foundation

extension Array {
    ///https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
    public func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
