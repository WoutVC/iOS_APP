import SwiftUI

@main
struct MacOSExamAppApp: App {
    @StateObject private var viewModel = GameListViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                GameListView(viewModel: viewModel)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                YourGamesView(viewModel: viewModel)
                    .tabItem {
                        Label("Your Games", systemImage: "star")
                    }
            }
        }
    }
}
