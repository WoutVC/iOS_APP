import SwiftUI

struct GameDetailScreen: View {
    @ObservedObject var viewModel: GameListViewModel
    let game: Game

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: game.thumbnail)) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                            } placeholder: {
                                ProgressView()
                                    .frame(maxWidth: .infinity, minHeight: 200)
                            }

                            Text(game.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text("Genre: \(game.genre)")
                                .font(.headline)

                            Text("Platform: \(game.platform)")
                                .font(.subheadline)

                            Text("Publisher: \(game.publisher)")
                                .font(.subheadline)

                            Text("Developer: \(game.developer)")
                                .font(.subheadline)

                            Text("Release Date: \(game.releaseDate)")
                                .font(.subheadline)

                            Text("Description:")
                                .font(.headline)
                                .padding(.top, 10)

                            Text(game.shortDescription)
                                .font(.body)
            .padding()

            HStack {
                Button(action: {
                    viewModel.toggleFavorite(game: game)
                }) {
                    Image(systemName: game.isFavorite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .imageScale(.large)
                }

                Button(action: {
                    viewModel.togglePlayLater(game: game)
                }) {
                    Image(systemName: game.isPlayLater ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }

                Button(action: {
                    viewModel.toggleCompleted(game: game)
                }) {
                    Image(systemName: game.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.green)
                        .imageScale(.large)
                }
            }
            .padding()
        }
        .navigationTitle("Game Details")
    }
}
