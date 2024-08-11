import SwiftUI

struct GameListView: View {
    @StateObject var viewModel = GameListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                TextField("Search", text: $viewModel.searchQuery)
                    .padding()
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // List of games
                List(viewModel.filteredGames) { game in
                    GameRow(game: game, viewModel: viewModel)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Game Shop")
        }
    }
}

// Subview for each game in the list
struct GameRow: View {
    var game: Game
    var viewModel: GameListViewModel
    
    var body: some View {
        HStack {
            // Display the game image
            AsyncImage(url: URL(string: game.thumbnail)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text(game.title)
                    .font(.headline)
                Text(game.shortDescription)
                    .font(.subheadline)
                    .lineLimit(2)
                if let genre = game.genre {
                    Text("Genre: \(genre)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                if let platform = game.platform {
                    Text("Platform: \(platform)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.toggleFavorite(game: game)
            }) {
                Image(systemName: game.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(game.isFavorite ? .red : .gray)
            }
            
            Button(action: {
                viewModel.addToCart(game: game)
            }) {
                Image(systemName: "cart")
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
}
