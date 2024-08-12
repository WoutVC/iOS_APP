import SwiftUI

struct GameListView: View {
    @ObservedObject var viewModel: GameListViewModel

    var body: some View {
        NavigationView {
            List(viewModel.allGames) { game in
                NavigationLink(destination: GameDetailScreen(viewModel: viewModel, game: game)) {
                    GameRow(game: game)
                }
            }
            .navigationTitle("All Games")
        }
        .onAppear {
            viewModel.fetchGames()
        }
    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView(viewModel: GameListViewModel())
    }
}
