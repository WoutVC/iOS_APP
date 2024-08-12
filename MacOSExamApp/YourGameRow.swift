import SwiftUI

struct YourGameRow: View {
    let game: Game
        let removeAction: () -> Void

        var body: some View {
            HStack {
                AsyncImage(url: URL(string: game.thumbnail)) { image in
                    image.resizable()
                        .frame(width: 122, height: 69)
                } placeholder: {
                    ProgressView()
                        .frame(width: 10, height: 10)
                }

                VStack(alignment: .leading) {
                    Text(game.title)
                        .font(.headline)
                    Text(game.genre)
                        .font(.subheadline)
                    Text(game.platform)
                        .font(.caption)
                }

                Spacer()

                Button(action: removeAction) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.red)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding(.trailing, 10)
            }
            .padding()
        }
    }
