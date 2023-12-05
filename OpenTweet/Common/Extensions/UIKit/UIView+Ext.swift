import UIKit

extension UIView {
    /// This returns name of the `xib` in string format.
    static var nibName: String {
        return String(describing: self)
    }
}
