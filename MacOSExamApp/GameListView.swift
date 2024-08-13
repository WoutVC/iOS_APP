import SwiftUI

struct GameListView: View {
    @ObservedObject var viewModel: GameListViewModel

    var body: some View {
        NavigationView {
            VStack {
                Menu {
                    ForEach(viewModel.allGenres, id: \.self) { genre in
                        Button(action: {
                            viewModel.selectedGenre = genre
                        }) {
                            Text(genre)
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedGenre)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground).opacity(0.1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                }
                .padding()

                List(viewModel.filteredGames) { game in
                    NavigationLink(destination: GameDetailScreen(viewModel: viewModel, game: game)) {
                        GameRow(game: game)
                    }
                }
                .navigationTitle("All Games")
            }
        }
    }
}
struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView(viewModel: GameListViewModel())
    }
}
