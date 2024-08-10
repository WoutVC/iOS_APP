import SwiftUI
import Combine

/// ViewModel class responsible for data related to the homescreen and API states.
/// Manages API states and provides data streams for games.
class GameViewModel: ObservableObject {
    @Published var gameApiState: GameApiState = .loading
    @Published var uiListState: [Game] = []
    @Published var gameState: Game = Game.default
    @Published var favoriteGamesState: [Game] = []
    @Published var playLaterGamesState: [Game] = []
    @Published var completedGamesState: [Game] = []

    private var gamesRepository: GamesRepository
    private var preferences: UserDefaults
    private var cancellables = Set<AnyCancellable>()

    init(gamesRepository: GamesRepository, preferences: UserDefaults = UserDefaults.standard) {
        self.gamesRepository = gamesRepository
        self.preferences = preferences
        fetchGames()
        getGame(id: 1)
        loadGamesFromPreferences()
    }

    private func loadGamesFromPreferences() {
        favoriteGamesState = loadGames(key: "favoriteGames")
        playLaterGamesState = loadGames(key: "playLaterGames")
        completedGamesState = loadGames(key: "completedGames")
    }

    private func loadGames(key: String) -> [Game] {
        guard let data = preferences.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Game].self, from: data)) ?? []
    }

    private func saveGames(key: String, games: [Game]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(games) {
            preferences.set(data, forKey: key)
        }
    }

    func addToFavorites(game: Game) {
        favoriteGamesState.append(game)
        saveGames(key: "favoriteGames", games: favoriteGamesState)
    }

    func addToPlayLater(game: Game) {
        playLaterGamesState.append(game)
        saveGames(key: "playLaterGames", games: playLaterGamesState)
    }

    func addToCompleted(game: Game) {
        completedGamesState.append(game)
        saveGames(key: "completedGames", games: completedGamesState)
    }

    func removeFromFavorites(game: Game) {
        favoriteGamesState.removeAll { $0.id == game.id }
        saveGames(key: "favoriteGames", games: favoriteGamesState)
    }

    func removeFromPlayLater(game: Game) {
        playLaterGamesState.removeAll { $0.id == game.id }
        saveGames(key: "playLaterGames", games: playLaterGamesState)
    }

    func removeFromCompleted(game: Game) {
        completedGamesState.removeAll { $0.id == game.id }
        saveGames(key: "completedGames", games: completedGamesState)
    }

    func isGameInFavorites(game: Game) -> Bool {
        favoriteGamesState.contains { $0.id == game.id }
    }

    func isGameInPlayLater(game: Game) -> Bool {
        playLaterGamesState.contains { $0.id == game.id }
    }

    func isGameInCompleted(game: Game) -> Bool {
        completedGamesState.contains { $0.id == game.id }
    }

    func getGame(id: Int) {
        gameApiState = .loading
        gamesRepository.getGame(id: id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.gameApiState = .success
                case .failure:
                    self.gameApiState = .error
                }
            }, receiveValue: { game in
                self.gameState = game
            })
            .store(in: &cancellables)
    }

    func fetchGames() {
        gamesRepository.refresh()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.gameApiState = .success
                case .failure:
                    self.gameApiState = .error
                }
            }, receiveValue: { games in
                self.uiListState = games
            })
            .store(in: &cancellables)
    }
}
