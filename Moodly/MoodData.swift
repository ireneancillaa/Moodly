import Foundation
import SwiftData

@Model
class MoodData {
    var date: Date
    var mood: Int
    
    init(date: Date = Date(), mood: Int) {
        self.date = date
        self.mood = mood
    }
    
    var moodEnum: Mood {
        Mood(rawValue: mood) ?? .neutral
    }
}
