import SwiftUI

struct GameDetailScreen: View {
    @StateObject private var gameViewModel = GameViewModel()
    let game: Game
    let onBack: () -> Void

    var body: some View {
        VStack {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding()
            
            ScrollView {
                switch gameViewModel.gameApiState {
                case .error:
                    Text("Failed to load data.")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)

                case .loading:
                    Text("Loading data...")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)

                case .success(let gameDetail):
                    VStack(spacing: 20) {
                        Text(gameDetail.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()

                        if let url = URL(string: gameDetail.thumbnail) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .frame(width: 200, height: 200)
                            } placeholder: {
                                ProgressView()
                            }
                        }

                        Text(gameDetail.shortDescription)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()

                        if let genre = gameDetail.genre {
                            Text(genre)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                        }

                        if !gameDetail.developer.isEmpty {
                            Text(gameDetail.developer)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                        }

                        if !gameDetail.platform.isEmpty {
                            Text(gameDetail.platform)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding()
                        }

                        HStack {
                            Button(action: {
                                if gameViewModel.isGameInFavorites(gameDetail) {
                                    gameViewModel.removeFromFavorites(gameDetail)
                                } else {
                                    gameViewModel.addToFavorites(gameDetail)
                                }
                            }) {
                                Image(systemName: gameViewModel.isGameInFavorites(gameDetail) ? "star.fill" : "star")
                                    .foregroundColor(gameViewModel.isGameInFavorites(gameDetail) ? .yellow : .primary)
                            }

                            Button(action: {
                                if gameViewModel.isGameInPlayLater(gameDetail) {
                                    gameViewModel.removeFromPlayLater(gameDetail)
                                } else {
                                    gameViewModel.addToPlayLater(gameDetail)
                                }
                            }) {
                                Image(systemName: "clock")
                                    .foregroundColor(gameViewModel.isGameInPlayLater(gameDetail) ? .blue : .primary)
                            }

                            Button(action: {
                                if gameViewModel.isGameInCompleted(gameDetail) {
                                    gameViewModel.removeFromCompleted(gameDetail)
                                } else {
                                    gameViewModel.addToCompleted(gameDetail)
                                }
                            }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(gameViewModel.isGameInCompleted(gameDetail) ? .green : .primary)
                            }
                        }
                        .padding(.top, 20)
                    }
                }
            }
        }
        .onAppear {
            gameViewModel.getGame(game.id)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}

// Dummy Data Model and ViewModel for the SwiftUI Preview
struct Game: Identifiable {
    let id: String
    let title: String
    let thumbnail: String
    let shortDescription: String
    let genre: String
    let developer: String
    let platform: String
}

class GameViewModel: ObservableObject {
    @Published var gameApiState: GameApiState = .loading
    func getGame(_ id: String) {
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.gameApiState = .success(Game(id: id, title: "Sample Game", thumbnail: "https://example.com/image.png", shortDescription: "A short description of the game.", genre: "Action", developer: "Sample Developer", platform: "PC"))
        }
    }
    func isGameInFavorites(_ game: Game) -> Bool { return false }
    func addToFavorites(_ game: Game) {}
    func removeFromFavorites(_ game: Game) {}
    func isGameInPlayLater(_ game: Game) -> Bool { return false }
    func addToPlayLater(_ game: Game) {}
    func removeFromPlayLater(_ game: Game) {}
    func isGameInCompleted(_ game: Game) -> Bool { return false }
    func addToCompleted(_ game: Game) {}
    func removeFromCompleted(_ game: Game) {}
}

enum GameApiState {
    case loading
    case success(Game)
    case error
}

struct GameDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailScreen(game: Game(id: "1", title: "Sample Game", thumbnail: "", shortDescription: "", genre: "", developer: "", platform: ""), onBack: {})
    }
}
