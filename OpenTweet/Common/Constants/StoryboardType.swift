import UIKit

/// `enum` of different names of storyboard used in the application
enum StoryboardType: String {
    case timeline = "Timeline"
    
    /// This computable variable returns a storyboard instance by name
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }
}
