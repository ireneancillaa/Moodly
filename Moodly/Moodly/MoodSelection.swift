import Foundation
import SwiftUI
import SwiftData

struct MoodSelection: View {
    @Environment(\.modelContext) var context
    @Query(sort: \MoodData.date, order: .reverse) var moodDatas: [MoodData]
    @State private var sliderValue: Double = 0
    
    var editMood: Date? = nil
    
    var currentMood: Mood {
        Mood(rawValue: Int(sliderValue)) ?? .neutral
    }
    
    var body: some View {
        ZStack {
            currentMood.color.opacity(0.2)
                .ignoresSafeArea()
            
            VStack {
                Text("How are you feeling today?") .font(.system(size: 35, weight: .bold))  .multilineTextAlignment(.center)
                Spacer().frame(height: 50)
                
                Text(currentMood.emoji)
                    .font(.system(size: 200))
                
                Text(currentMood.desc)
                    .font(.system(size: 20, weight: .medium))
                    .multilineTextAlignment(.center)
                Spacer().frame(height: 50)
                
                Slider(value: $sliderValue, in: 0...4, step: 1)
                    .tint(currentMood.color)
                Spacer().frame(height: 25)
                
                Button {
                    saveMood()
                } label: {
                    Text("Confirm")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(currentMood.color)
                        .clipShape(Capsule())
                }
            }
            .padding(45)
            .onAppear {
                if let editMood = editMood,
                   let moodData = moodDatas.first(where: { $0.date.startOfDay == editMood.startOfDay }) {
                    sliderValue = Double(moodData.mood)
                }
            }
        }
    }
    
    private func saveMood() {
        if let editMood = editMood,
           let moodDataIndex = moodDatas.first(where: { $0.date.startOfDay == editMood.startOfDay }) {
            moodDataIndex.mood = Int(sliderValue)
        } else {
            let newMood = MoodData(date: (editMood ?? Date()).startOfDay, mood: Int(sliderValue))
            context.insert(newMood)
        }
        try? context.save()
    }
}

#Preview {
    MoodSelection()
}
