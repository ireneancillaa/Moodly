import SwiftUI
import SwiftData

@main
struct MoodlyApp: App {
    var body: some Scene {
        WindowGroup {
            MainPage()
        }
        .modelContainer(for: MoodData.self)
    }
}
