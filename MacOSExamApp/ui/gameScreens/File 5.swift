import SwiftUI

/// SwiftUI view for the "Your Games" screen.
struct YourGamesScreen: View {
    @State private var selectedGame: Game?
    var innerPadding: EdgeInsets

    var body: some View {
        NavigationView {
            VStack {
                if let selectedGame = selectedGame {
                    GameDetailScreen(game: selectedGame, onBack: { self.selectedGame = nil })
                } else {
                    GamesScreen(innerPadding: innerPadding) { game in
                        self.selectedGame = game
                    }
                }
            }
            .padding(innerPadding)
        }
    }
}

/// SwiftUI view displaying different sections of games.
struct GamesScreen: View {
    @StateObject private var gameViewModel = GameViewModel(gamesRepository: GamesRepository())
    var innerPadding: EdgeInsets
    var onGameClick: (Game) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Spacer().frame(height: 10)
                YourGamesTitle()
                Spacer().frame(height: 20)

                // Display favorite games
                GamesListSection(title: "Favorites", games: gameViewModel.favoriteGamesState.prefix(20).map { $0 }, onGameClick: onGameClick)

                // Display play later games
                GamesListSection(title: "Play Later", games: gameViewModel.playLaterGamesState.prefix(20).map { $0 }, onGameClick: onGameClick)

                // Display completed games
                GamesListSection(title: "Completed", games: gameViewModel.completedGamesState.prefix(20).map { $0 }, onGameClick: onGameClick)
            }
            .padding(innerPadding)
        }
    }
}

/// SwiftUI view for displaying the "Your Games" title.
struct YourGamesTitle: View {
    var body: some View {
        VStack {
            Text("Your Games")
                .font(.system(size: 25, weight: .bold))
                .padding(8)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

/// SwiftUI view for displaying a section of games.
struct GamesListSection: View {
    var title: String
    var games: [Game]
    var onGameClick: (Game) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 25, weight: .bold))
                .padding(8)
                .multilineTextAlignment(.center)

            if games.isEmpty {
                Text("No games added to this list")
                    .font(.system(size: 16))
                    .padding(8)
                    .multilineTextAlignment(.center)
            } else {
                ForEach(games) { game in
                    GameCard(game: game, onClick: { onGameClick(game) })
                    Spacer().frame(height: 20)
                }
            }
        }
        .padding(16)
    }
}

/// SwiftUI view rendering a card representing a game.
struct GameCard: View {
    var game: Game
    var onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            HStack {
                Image(uiImage: loadImage(from: game.thumbnail))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading) {
                    Text(game.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 4)
                    
                    Text(game.shortDescription)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
                .padding(.leading, 8)
            }
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private func loadImage(from urlString: String) -> UIImage {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return UIImage(systemName: "photo") ?? UIImage()
        }
        return image
    }
}

/// Dummy models and view model for demonstration
struct Game: Identifiable {
    var id: UUID = UUID()
    var title: String
    var shortDescription: String
    var thumbnail: String
}

class GameViewModel: ObservableObject {
    @Published var favoriteGamesState: [Game] = []
    @Published var playLaterGamesState: [Game] = []
    @Published var completedGamesState: [Game] = []
    
    init(gamesRepository: GamesRepository) {
        // Load games from repository
    }
}

class GamesRepository {
    // Dummy repository class
}

struct ContentView: View {
    var body: some View {
        YourGamesScreen(innerPadding: EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
