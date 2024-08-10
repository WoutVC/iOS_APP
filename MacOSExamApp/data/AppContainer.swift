import Foundation
import Alamofire
import RealmSwift
import Moya
import SwiftyJSON

/**
 * `AppContainer` provides instances of game-related repositories and services required by the application.
 */
protocol AppContainer {
    var gamesRepository: GamesRepository { get }
}

/**
 * Default implementation of the `AppContainer` providing instances of game-related repositories
 * and services required by the application.
 *
 * @property applicationContext The application context.
 */
class DefaultAppContainer: AppContainer {

    private let baseUrl = "https://www.freetogame.com/api/"

    private lazy var networkProvider: MoyaProvider<GameApiService> = {
        let endpointClosure = { (target: GameApiService) -> Endpoint in
            let url = "\(self.baseUrl)\(target.path)"
            return Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
        
        let plugins: [PluginType] = [NetworkLoggerPlugin()]
        
        return MoyaProvider<GameApiService>(endpointClosure: endpointClosure, plugins: plugins)
    }()

    private lazy var realm: Realm = {
        do {
            let realm = try Realm()
            return realm
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }()

    private lazy var gamesRepository: GamesRepository = {
        return CachingGamesRepository(gameDao: realm, gameApiService: networkProvider)
    }()

    var gamesRepository: GamesRepository {
        return gamesRepository
    }
}
