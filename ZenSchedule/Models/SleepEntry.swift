import Foundation
import SwiftData

@Model
final class SleepEntry {
    
    // MARK: - Saved Information
    
    var bedtime: Date
    var wakeUpTime: Date
    var sleepQuality: String
    var stressLevel: Double
    var energyLevel: Double
    var notes: String
    var createdAt: Date
    
    // MARK: - Initialiser
    
    init(
        bedtime: Date,
        wakeUpTime: Date,
        sleepQuality: String,
        stressLevel: Double,
        energyLevel: Double,
        notes: String,
        createdAt: Date = Date()
    ) {
        self.bedtime = bedtime
        self.wakeUpTime = wakeUpTime
        self.sleepQuality = sleepQuality
        self.stressLevel = stressLevel
        self.energyLevel = energyLevel
        self.notes = notes
        self.createdAt = createdAt
    }
    
    // MARK: - Calculated Sleep Duration
    
    var totalSleepMinutes: Int {
        let difference = wakeUpTime.timeIntervalSince(bedtime)
        return max(Int(difference / 60), 0)
    }
    
    var formattedSleepDuration: String {
        let hours = totalSleepMinutes / 60
        let minutes = totalSleepMinutes % 60
        
        return "\(hours)h \(minutes)m"
    }
}
