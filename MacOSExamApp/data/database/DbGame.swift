import CoreData

extension DbGame {
    func asDomainGame() -> Game {
        return Game(
            id: Int(id),
            title: title ?? "",
            thumbnail: thumbnail ?? "",
            shortDescription: shortDescription ?? "",
            gameUrl: gameUrl ?? "",
            genre: genre ?? "",
            platform: platform ?? "",
            publisher: publisher ?? "",
            developer: developer ?? "",
            releaseDate: releaseDate ?? "",
            freeToGameProfileUrl: freeToGameProfileUrl ?? ""
        )
    }
}

extension Game {
    func asDbGame(context: NSManagedObjectContext) -> DbGame {
        let dbGame = DbGame(context: context)
        dbGame.id = Int32(id)
        dbGame.title = title
        dbGame.thumbnail = thumbnail
        dbGame.shortDescription = shortDescription
        dbGame.gameUrl = gameUrl
        dbGame.genre = genre
        dbGame.platform = platform
        dbGame.publisher = publisher
        dbGame.developer = developer
        dbGame.releaseDate = releaseDate
        dbGame.freeToGameProfileUrl = freeToGameProfileUrl
        return dbGame
    }
}

extension Array where Element == DbGame {
    func asDomainObjects() -> [Game] {
        return map { $0.asDomainGame() }
    }
}
