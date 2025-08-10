import SwiftUI

struct ContentView: View {
    @State private var sliderValue: Double = 0
    
    enum Mood: Int, CaseIterable {
        case verySad = 0, sad, neutral, happy, veryHappy
        
        var emoji: String {
            switch self {
                case .verySad: return "😭"
                case .sad: return "☹️"
                case .neutral: return "😐"
                case .happy: return "😀"
                case .veryHappy: return "😆"
            }
        }
        
        var desc: String {
            switch self {
                case .verySad: return "Very Sad"
                case .sad: return "Sad"
                case .neutral: return "Neutral"
                case .happy: return "Happy"
                case .veryHappy: return "Very Happy"
            }
        }
    }
    
    var currentMood: Mood {
        Mood(rawValue: Int(sliderValue)) ?? .neutral
    }
    
    var body: some View {
        VStack {
            Text("How are you feeling today?")
                .font(.system(size: 35, weight: .bold))
                .multilineTextAlignment(.center)
            Spacer().frame(height: 50)
            
            Text(currentMood.emoji)
                .font(.system(size: 200))
            
            Text(currentMood.desc)
                .font(.system(size: 20, weight: .medium))
                .multilineTextAlignment(.center)
            Spacer().frame(height: 50)
            
            Slider(value: $sliderValue, in: 0...4, step: 1)
            Spacer().frame(height: 25)
            
            Button {
                
            } label: {
                Text("Confirm")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .clipShape(Capsule())
            }
        }
        .padding(45)
    }
}

#Preview {
    ContentView()
}
