import SwiftUI
import Auth0

struct GameApp: View {
    @State private var selectedItem = 0
    @EnvironmentObject var viewModel: GameAppViewModel
    
    private let items = ["Home", "Your Games", "Account"]
    
    var body: some View {
        NavigationView {
            VStack {
                TopAppBar(title: selectedTitle)
                
                Spacer()
                
                contentView
                
                Spacer()
                
                BottomAppBar(
                    items: items + [viewModel.cachedCredentials != nil ? "Logout" : "Login"],
                    selectedItem: $selectedItem,
                    onItemSelected: handleItemSelected
                )
            }
            .navigationBarHidden(true)
        }
    }
    
    private var selectedTitle: String {
        items[selectedItem]
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedItem {
        case 0:
            HomeScreen()
        case 1:
            YourGamesScreen()
        case 2:
            AccountScreen(userProfile: viewModel.cachedUserProfile)
        default:
            EmptyView()
        }
    }
    
    private func handleItemSelected(index: Int) {
        selectedItem = index
        if index == items.count {
            viewModel.cachedCredentials == nil ? viewModel.loginWithBrowser() : viewModel.logout()
        }
    }
}

struct TopAppBar: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}

struct BottomAppBar: View {
    var items: [String]
    @Binding var selectedItem: Int
    var onItemSelected: (Int) -> Void
    
    var body: some View {
        HStack {
            ForEach(items.indices, id: \.self) { index in
                Button(action: {
                    onItemSelected(index)
                }) {
                    VStack {
                        Image(systemName: systemImage(for: items[index]))
                        Text(items[index])
                    }
                    .padding()
                    .foregroundColor(selectedItem == index ? .blue : .gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .background(Color.gray.opacity(0.1))
    }
    
    private func systemImage(for item: String) -> String {
        switch item {
        case "Home":
            return "house"
        case "Your Games":
            return "star"
        case "Account":
            return "person.crop.circle"
        case "Login":
            return "person.crop.circle.badge.plus"
        case "Logout":
            return "person.crop.circle.badge.minus"
        default:
            return "questionmark.circle"
        }
    }
}

struct HomeScreen: View {
    var body: some View {
        Text("Home Screen")
            .padding()
    }
}

struct YourGamesScreen: View {
    var body: some View {
        Text("Your Games Screen")
            .padding()
    }
}

struct AccountScreen: View {
    var userProfile: UserInfo?
    
    var body: some View {
        if let profile = userProfile {
            Text("Welcome, \(profile.name ?? "User")")
                .padding()
        } else {
            Text("Account Screen")
                .padding()
        }
    }
}

struct GameApp_Previews: PreviewProvider {
    static var previews: some View {
        GameApp()
            .environmentObject(GameAppViewModel())
    }
}
		
