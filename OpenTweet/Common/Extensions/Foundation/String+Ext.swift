import Foundation

extension String {
    /// The localized string for the key represented in `self`.
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
