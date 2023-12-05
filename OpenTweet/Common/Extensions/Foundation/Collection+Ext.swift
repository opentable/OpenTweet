import Foundation

extension Collection {
    /// Safely retrieve the element at `index`
    ///
    /// - Parameter index: Subscript Index
    /// - Returns: Element of the array at that `index`
    func at(_ index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
