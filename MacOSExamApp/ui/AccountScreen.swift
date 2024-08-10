import SwiftUI

struct AccountScreen: View {
    var userProfile: UserInfo?
    var body: some View {
        ScrollView {
            VStack {
                if let profile = userProfile {
                    // Display user information if available
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Username: \(profile.name ?? "")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 5)
                            .padding(.top, 8)
                        
                        Text("Email: \(profile.email ?? "")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(16)
                } else {
                    // Display login message if user profile is empty
                    Text("Login to see your account")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(16)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
    }
}

struct AccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountScreen(userProfile: nil)
    }
}
