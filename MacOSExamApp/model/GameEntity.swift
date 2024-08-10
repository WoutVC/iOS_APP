import Foundation
import CoreData

@objc(GameEntity)
public class GameEntity: NSManagedObject {
    @NSManaged public var id: Int32
    @NSManaged public var title: String
    @NSManaged public var thumbnail: String
    @NSManaged public var shortDescription: String
    @NSManaged public var gameUrl: String
    @NSManaged public var genre: String
    @NSManaged public var platform: String
    @NSManaged public var publisher: String
    @NSManaged public var developer: String
    @NSManaged public var releaseDate: String
    @NSManaged public var freeToGameProfileUrl: String
    
    extension GameEntity: Identifiable {
        // For SwiftUI compatibility, add the id property to conform to Identifiable
        public var id: UUID {
            return UUID(uuidString: "\(self.id)") ?? UUID()
        }
    }
