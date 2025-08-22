import SwiftUI
import SwiftData

struct MoodEdit: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \MoodData.date, order: .reverse) var moodDatas: [MoodData]
    @State private var sliderValue: Double = 0
    
    var date: Date
    var currentMood: Mood {
        Mood(rawValue: Int(sliderValue)) ?? .neutral
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                currentMood.color.opacity(0.2)
                    .ignoresSafeArea()
                VStack {
                    Text("Mood for\n\(date.formatted(date: .abbreviated, time: .omitted))")
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
                        .tint(currentMood.color)
                    Spacer().frame(height: 25)
                    
                    Button {
                        saveMood()
                        dismiss()
                    } label: {
                        Text("Save Changes")
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
                    if let moodData = moodDatas.first(where: {
                        $0.date.startOfDay == date.startOfDay
                    }) {
                        sliderValue = Double(moodData.mood)
                    }
                }
            }
            .navigationTitle("Edit Mood")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func saveMood() {
        if let moodData = moodDatas.first(where: {
            $0.date.startOfDay == date.startOfDay
        }) {
            moodData.mood = Int(sliderValue)
        } else {
            let newMood = MoodData(date: date.startOfDay, mood: Int(sliderValue))
            context.insert(newMood)
        }
        try? context.save()
    }
}
