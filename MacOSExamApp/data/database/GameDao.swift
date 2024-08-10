import CoreData

class GameDataManager {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // Insert or update a game
    func insertOrUpdateGame(_ game: Game) {
        let dbGame = game.asDbGame(context: context)
        do {
            try context.save()
        } catch {
            print("Failed to save game: \(error)")
        }
    }
    
    // Retrieve all games
    func getGames() -> [Game] {
        let fetchRequest: NSFetchRequest<DbGame> = DbGame.fetchRequest()
        do {
            let dbGames = try context.fetch(fetchRequest)
            return dbGames.asDomainObjects()
        } catch {
            print("Failed to fetch games: \(error)")
            return []
        }
    }
    
    // Retrieve a game by ID
    func getGame(by id: Int) -> Game? {
        let fetchRequest: NSFetchRequest<DbGame> = DbGame.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let dbGames = try context.fetch(fetchRequest)
            return dbGames.first?.asDomainGame()
        } catch {
            print("Failed to fetch game with ID \(id): \(error)")
            return nil
        }
    }
}
