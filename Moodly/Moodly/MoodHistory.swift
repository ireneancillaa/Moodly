import SwiftUI
import SwiftData

struct IdentifiableDate: Identifiable {
    let id = UUID()
    let date: Date
}

struct MoodHistory: View {
    @Query(sort: \MoodData.date) var moods: [MoodData]
    
    @State private var displayedMonth: Date = Date()
    private var calendar = Calendar.current
    
    @State private var selectedDate: IdentifiableDate? = nil
    
    private var monthDates: [Date?] {
        let range = calendar.range(of: .day, in: .month, for: displayedMonth)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))!
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let leadingEmptyCount = firstWeekday - calendar.firstWeekday
        let placeholders = Array(repeating: Optional<Date>(nil), count: (leadingEmptyCount + 7) % 7)
        let days: [Date?] = range.compactMap { day -> Date? in
            let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
            return date
        }
        return placeholders + days
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.orange)
                        .font(.headline)
                }
                
                Spacer()
                
                Text(monthTitle(from: displayedMonth))
                    .font(.system(size: 24, weight: .bold))
                
                Spacer()
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.orange)
                        .font(.headline)
                }
            }
            .padding()
            
            let daySymbols = calendar.shortWeekdaySymbols
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daySymbols, id: \.self) { day in
                    Text(day.prefix(1))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(Array(monthDates.enumerated()), id: \.offset) { idx, day in
                    if let day = day {
                        let moodForDay = moods.filter {
                            $0.date.startOfDay == day.startOfDay
                        }.last
                        let isToday = calendar.isDateInToday(day)
                        ZStack {
                            Circle()
                                .fill(moodForDay?.moodEnum.color.opacity(0.3) ?? .clear)
                                .frame(width: 38, height: 38)
                            if isToday {
                                Text("\(calendar.component(.day, from: day))")
                                    .font(.caption .bold())
                                    .foregroundColor(.blue)
                            } else {
                                Text("\(calendar.component(.day, from: day))")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                        .onTapGesture {
                            selectedDate = IdentifiableDate(date: day)
                        }
                    } else {
                        Text("")
                            .frame(width: 38, height: 38)
                    }
                }
            }
            .id(moods)
            
            Spacer()
        }
        .padding()
        .sheet(item: $selectedDate) { identifiableDate in
            MoodEdit(date: identifiableDate.date)
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }
    
    private func monthTitle(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    MoodHistory()
}
