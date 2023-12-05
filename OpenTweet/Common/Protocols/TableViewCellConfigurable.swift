import Foundation

/// Provides a way to inject a view model inside the table view cell
protocol TableViewCellConfigurable {
    associatedtype Info
    func configure(withInfo info: Info)
}
