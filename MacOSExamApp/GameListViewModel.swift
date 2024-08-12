import SwiftUI
import Combine

class GameListViewModel: ObservableObject {
    @Published var allGames: [Game] = []
    @Published var favoriteGames: [Game] = []
    @Published var playLaterGames: [Game] = []
    @Published var completedGames: [Game] = []

    private var cancellables = Set<AnyCancellable>()
    private var gameService = GameService()

    init() {
        loadGames()
        fetchGames()
    }

    func fetchGames() {
            gameService.fetchGames()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching games: \(error)")
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] games in
                    self?.allGames = games
                    self?.updateCategorizedGames()
                })
                .store(in: &cancellables)
        }

    func getFavorites() -> [Game] {
        allGames.filter { $0.isFavorite }
    }

    func getPlayLater() -> [Game] {
        allGames.filter { $0.isPlayLater }
    }

    func getCompleted() -> [Game] {
        allGames.filter { $0.isCompleted }
    }

    func toggleFavorite(game: Game) {
        if let index = allGames.firstIndex(where: { $0.id == game.id }) {
            allGames[index].isFavorite.toggle()
            saveGames()
            updateCategorizedGames()
        }
    }

    func togglePlayLater(game: Game) {
        if let index = allGames.firstIndex(where: { $0.id == game.id }) {
            allGames[index].isPlayLater.toggle()
            saveGames()
            updateCategorizedGames()
        }
    }

    func toggleCompleted(game: Game) {
        if let index = allGames.firstIndex(where: { $0.id == game.id }) {
            allGames[index].isCompleted.toggle()
            saveGames()
            updateCategorizedGames()
        }
    }
    
    private func saveGames() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allGames) {
            UserDefaults.standard.set(encoded, forKey: "savedGames")
        }
    }

    private func loadGames() {
        if let savedGamesData = UserDefaults.standard.data(forKey: "savedGames") {
            let decoder = JSONDecoder()
            if let decodedGames = try? decoder.decode([Game].self, from: savedGamesData) {
                allGames = decodedGames
                updateCategorizedGames()
            }
        }
    }
    
    private func updateCategorizedGames() {
        favoriteGames = getFavorites()
        playLaterGames = getPlayLater()
        completedGames = getCompleted()
    }
}
