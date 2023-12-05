import Foundation

/// `Error` which can be used for application error transmission
enum ApplicationError: Error {
    case localFileTweetsFetchingFailedDueToFileNotFound
}
