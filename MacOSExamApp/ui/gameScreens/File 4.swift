import SwiftUI
import Combine

/// SwiftUI view representing the home screen of the app.
struct HomeScreen: View {
    @State private var selectedGame: Game?

    var body: some View {
        NavigationView {
            VStack {
                if let selectedGame = selectedGame {
                    GameDetailScreen(game: selectedGame, onBack: { self.selectedGame = nil })
                } else {
                    GameListScreen(onGameClick: { game in
                        self.selectedGame = game
                    })
                }
            }
        }
    }
}

/// SwiftUI view displaying a list of games.
struct GameListScreen: View {
    @StateObject private var gameViewModel = GameViewModel(gamesRepository: GamesRepository())
    var onGameClick: (Game) -> Void

    var body: some View {
        VStack {
            Welcome()
            Spacer().frame(height: 20)
            switch gameViewModel.gameApiState {
            case .error:
                Text("De data kon niet geladen worden.")
                    .frame(maxWidth: .infinity, alignment: .center)
            case .loading:
                Text("Laden...")
                    .frame(maxWidth: .infinity, alignment: .center)
            case .success:
                GameColumn(gameList: gameViewModel.uiListState.prefix(20).map { $0 }, onGameClick: onGameClick)
            }
        }
        .padding()
    }
}

/// SwiftUI view rendering the welcome message.
struct Welcome: View {
    var body: some View {
        VStack {
            Text("Welcome to the\nGame App")
                .font(.system(size: 25, weight: .bold))
                .padding(8)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

/// SwiftUI view displaying a column of games.
struct GameColumn: View {
    var gameList: [Game]
    var onGameClick: (Game) -> Void

    var body: some View {
        List(gameList) { game in
            GameCard(game: game, onClick: {
                onGameClick(game)
            })
            .padding(.vertical, 10)
        }
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

struct ContentView: View {
    var body: some View {
        HomeScreen()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
