import Foundation

class GameService {
    private let baseURL = "https://www.freetogame.com/api"
    
    func fetchGames(completion: @escaping (Result<[Game], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/games")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let games = try decoder.decode([Game].self, from: data)
                completion(.success(games))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}	
