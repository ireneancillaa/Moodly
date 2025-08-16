import Foundation
import SwiftUI

struct MainPage: View {
    var body: some View {
        TabView {
            MoodSelection()
                .tabItem {
                    Label("Mood", systemImage: "square.and.pencil")
                }
            
            MoodHistory()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }
        .tint(Color.black)
    }
}

#Preview {
    MainPage()
}
