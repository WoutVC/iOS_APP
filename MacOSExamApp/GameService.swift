import Foundation
import Combine

class GameService {
    func fetchGames() -> AnyPublisher<[Game], Error> {
        guard let url = URL(string: "https://www.freetogame.com/api/games") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Game].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
