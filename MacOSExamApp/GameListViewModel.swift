import Combine
import SwiftUI

class GameListViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var searchQuery: String = ""
    @Published var cart: [Game] = []
    
    private var gameService = GameService()
    
    init() {
        fetchGames()
    }
    
    func fetchGames() {
        gameService.fetchGames { [weak self] result in
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self?.games = games
                }
            case .failure(let error):
                print("Error fetching games: \(error)")
            }
        }
    }
    
    func addToCart(game: Game) {
        cart.append(game)
    }
    
    func toggleFavorite(game: Game) {
        if let index = games.firstIndex(where: { $0.id == game.id }) {
            games[index].isFavorite.toggle()
        }
    }
    
    var filteredGames: [Game] {
        if searchQuery.isEmpty {
            return games
        } else {
            return games.filter { $0.title.lowercased().contains(searchQuery.lowercased()) }
        }
    }
}
