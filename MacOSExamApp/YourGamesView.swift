import SwiftUI

struct YourGamesView: View {
    @ObservedObject var viewModel: GameListViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Favorites")
                    .font(.headline)
                    .foregroundColor(.yellow)) {
                    if viewModel.favoriteGames.isEmpty {
                        Text("You don't have any favorite games.")
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                    } else {
                        ForEach(viewModel.favoriteGames) { game in
                            YourGameRow(game: game) {
                                viewModel.toggleFavorite(game: game)
                            }
                            .swipeActions {
                                Button(action: {
                                    viewModel.toggleFavorite(game: game)
                                }) {
                                    Label("Unfavorite", systemImage: "star.slash")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }

                Section(header: Text("Play Later")
                    .font(.headline)
                    .foregroundColor(.blue)) {
                    if viewModel.playLaterGames.isEmpty {
                        Text("You don't have any games to play later.")
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                    } else {
                        ForEach(viewModel.playLaterGames) { game in
                            YourGameRow(game: game) {
                                viewModel.togglePlayLater(game: game)
                            }
                            .swipeActions {
                                Button(action: {
                                    viewModel.togglePlayLater(game: game)
                                }) {
                                    Label("Remove", systemImage: "bookmark.slash")
                                }
                                .tint(.orange)
                            }
                        }
                    }
                }

                Section(header: Text("Completed")
                    .font(.headline)
                    .foregroundColor(.green)) {
                    if viewModel.completedGames.isEmpty {
                        Text("You don't have any completed games.")
                            .foregroundColor(.gray)
                            .italic()
                            .padding()
                    } else {
                        ForEach(viewModel.completedGames) { game in
                            YourGameRow(game: game) {
                                viewModel.toggleCompleted(game: game)
                            }
                            .swipeActions {
                                Button(action: {
                                    viewModel.toggleCompleted(game: game)
                                }) {
                                    Label("Mark as Incomplete", systemImage: "checkmark.circle.fill")
                                }
                                .tint(.green)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Your Games")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
