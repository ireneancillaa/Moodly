import Foundation
import SwiftUI

enum Mood: Int, CaseIterable, Codable {
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
    
    var color: Color {
        switch self {
            case .verySad: return .red
            case .sad: return .orange
            case .neutral: return .yellow
            case .happy: return .green
            case .veryHappy: return .blue
        }
    }
}
