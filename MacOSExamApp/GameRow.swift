import SwiftUI

struct GameRow: View {
    let game: Game

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: game.thumbnail)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .frame(width: 120, height: 80)
            } placeholder: {
                ProgressView()
                    .frame(width: 120, height: 80)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(game.title)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(game.genre)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(game.platform)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.leading, 40)
            .padding(.trailing, 10)

            Spacer()
        }
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.horizontal)
    }
}
