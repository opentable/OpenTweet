import UIKit

extension UITableView {
    /// This registers a cell of a known type to the table view.
    ///
    /// - Parameter cell: Type of the cell required to be registered.
    func register(cell: UITableViewCell.Type) {
        register(UINib(nibName: cell.nibName, bundle: Bundle.main), forCellReuseIdentifier: cell.nibName)
    }
    
    /// This dequeues cell of type to the table view.
    ///
    /// - Parameters:
    ///   - cell: Type of the cell required to be registered.
    ///   - indexPath: Indexpath of the cell required to be registered.
    /// - Returns: Instance of `Type` of the cell.
    func dequeue<Cell: UITableViewCell>(cell: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: cell.nibName, for: indexPath) as? Cell else {
            return Cell()
        }
        return cell
    }
}
