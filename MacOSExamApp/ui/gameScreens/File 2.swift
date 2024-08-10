import Foundation

/// Represents the possible states of a Game API operation.
enum GameApiState {
    /// Represents the loading state of the API response.
    case loading
    
    /// Represents the error state of the API response.
    case error
    
    /// Represents the success state of the API response.
    case success
}
