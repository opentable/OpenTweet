import UIKit

extension UIStoryboard {
    /// This method creates the instance of a view controller with specified type.
    ///
    /// - Parameter type: Type of the controller being used as storyboard identifier
    /// - Returns: Controller of the specified type
    func instantiateController<Controller: UIViewController>(withType type: Controller.Type) -> Controller {
        let identifier = String(describing: type.self)
        guard let controller = instantiateViewController(withIdentifier: identifier) as? Controller else {
            fatalError("A view controller with identifier '\(identifier)' wasn't found to be of type '\(type)'.")
        }
        return controller
    }
}
