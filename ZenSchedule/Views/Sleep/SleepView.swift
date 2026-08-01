import SwiftUI
import SwiftData

struct SleepView: View {
    
    // MARK: - Saved Sleep Entries
    
    @Query(
        sort: \SleepEntry.createdAt,
        order: .reverse
    )
    private var sleepEntries: [SleepEntry]
    
    // MARK: - Page State
    
    @State private var showingAddSleepEntry = false
    
    // MARK: - Page
    
    var body: some View {
        
        ZStack {
            
            // MARK: - Background
            
            Color(
                red: 0.96,
                green: 0.97,
                blue: 1.00
            )
            .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack(
                    alignment: .leading,
                    spacing: 20
                ) {
                    
                    // MARK: - Header
                    
                    HStack {
                        
                        VStack(
                            alignment: .leading,
                            spacing: 5
                        ) {
                            
                            Text("Sleep Tracker")
                                .font(
                                    .system(
                                        size: 34,
                                        weight: .bold
                                    )
                                )
                            
                            Text("Track your sleep and wellbeing.")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 34))
                            .foregroundColor(.indigo)
                    }
                    
                    // MARK: - Latest Sleep Entry
                    
                    if let latestEntry = sleepEntries.first {
                        
                        latestSleepCard(latestEntry)
                        
                    } else {
                        
                        emptySleepCard
                    }
                    
                    // MARK: - Weekly Average
                    
                    weeklyAverageCard
                    
                    // MARK: - Add Sleep Button
                    
                    Button {
                        showingAddSleepEntry = true
                    } label: {
                        
                        HStack {
                            
                            Image(systemName: "plus")
                            
                            Text("Log Sleep")
                        }
                        .font(
                            .system(
                                size: 17,
                                weight: .bold
                            )
                        )
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.indigo)
                        .cornerRadius(16)
                    }
                    
                    // MARK: - Sleep History Heading
                    
                    Text("Sleep History")
                        .font(
                            .system(
                                size: 21,
                                weight: .bold
                            )
                        )
                    
                    // MARK: - Sleep History
                    
                    if sleepEntries.isEmpty {
                        
                        Text("No sleep entries saved yet.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                        
                    } else {
                        
                        VStack(spacing: 12) {
                            
                            ForEach(sleepEntries) { entry in
                                
                                SleepHistoryCard(entry: entry)
                            }
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 18)
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingAddSleepEntry) {
            
            AddSleepEntryView()
        }
    }
    
    // MARK: - Latest Sleep Card
    
    private func latestSleepCard(
        _ entry: SleepEntry
    ) -> some View {
        
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            
            Text("Last Sleep")
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
            
            HStack {
                
                VStack(
                    alignment: .leading,
                    spacing: 5
                ) {
                    
                    Text(entry.formattedSleepDuration)
                        .font(
                            .system(
                                size: 38,
                                weight: .bold
                            )
                        )
                        .foregroundColor(.indigo)
                    
                    Text(
                        entry.createdAt.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "moon.zzz.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.indigo.opacity(0.8))
            }
            
            Divider()
            
            HStack {
                
                SleepStat(
                    title: "Quality",
                    value: entry.sleepQuality,
                    icon: "star.fill"
                )
                
                Spacer()
                
                SleepStat(
                    title: "Stress",
                    value: "\(Int(entry.stressLevel))/10",
                    icon: "brain.head.profile"
                )
                
                Spacer()
                
                SleepStat(
                    title: "Energy",
                    value: "\(Int(entry.energyLevel))/10",
                    icon: "bolt.fill"
                )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(
            color: .black.opacity(0.07),
            radius: 8,
            x: 0,
            y: 4
        )
    }
    
    // MARK: - Empty Sleep Card
    
    private var emptySleepCard: some View {
        
        VStack(spacing: 12) {
            
            Image(systemName: "moon.zzz")
                .font(.system(size: 42))
                .foregroundColor(.gray)
            
            Text("No sleep recorded")
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )
            
            Text("Tap Log Sleep to record your first night.")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(
            color: .black.opacity(0.06),
            radius: 7,
            x: 0,
            y: 3
        )
    }
    
    // MARK: - Weekly Average Card
    
    private var weeklyAverageCard: some View {
        
        HStack {
            
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                
                Text("Weekly Average")
                    .font(
                        .system(
                            size: 15,
                            weight: .semibold
                        )
                    )
                
                Text(weeklyAverageText)
                    .font(
                        .system(
                            size: 26,
                            weight: .bold
                        )
                    )
                    .foregroundColor(.indigo)
            }
            
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 30))
                .foregroundColor(.indigo.opacity(0.7))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(
            color: .black.opacity(0.06),
            radius: 6,
            x: 0,
            y: 3
        )
    }
    
    // MARK: - Weekly Average Calculation
    
    private var entriesFromLastSevenDays: [SleepEntry] {
        
        guard let sevenDaysAgo = Calendar.current.date(
            byAdding: .day,
            value: -7,
            to: Date()
        ) else {
            return []
        }
        
        return sleepEntries.filter {
            $0.createdAt >= sevenDaysAgo
        }
    }
    
    private var weeklyAverageMinutes: Int {
        
        guard !entriesFromLastSevenDays.isEmpty else {
            return 0
        }
        
        let totalMinutes = entriesFromLastSevenDays.reduce(0) {
            result,
            entry in
            
            result + entry.totalSleepMinutes
        }
        
        return totalMinutes / entriesFromLastSevenDays.count
    }
    
    private var weeklyAverageText: String {
        
        let hours = weeklyAverageMinutes / 60
        let minutes = weeklyAverageMinutes % 60
        
        return "\(hours)h \(minutes)m"
    }
}

// MARK: - Sleep Statistic

struct SleepStat: View {
    
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        
        VStack(spacing: 5) {
            
            Image(systemName: icon)
                .foregroundColor(.indigo)
            
            Text(value)
                .font(
                    .system(
                        size: 14,
                        weight: .semibold
                    )
                )
            
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Sleep History Card

struct SleepHistoryCard: View {
    
    let entry: SleepEntry
    
    var body: some View {
        
        HStack(spacing: 14) {
            
            ZStack {
                
                Circle()
                    .fill(Color.indigo.opacity(0.12))
                    .frame(width: 54, height: 54)
                
                Image(systemName: "moon.fill")
                    .foregroundColor(.indigo)
            }
            
            VStack(
                alignment: .leading,
                spacing: 4
            ) {
                
                Text(
                    entry.createdAt.formatted(
                        date: .abbreviated,
                        time: .omitted
                    )
                )
                .font(
                    .system(
                        size: 15,
                        weight: .semibold
                    )
                )
                
                Text(
                    "\(formattedTime(entry.bedtime)) – \(formattedTime(entry.wakeUpTime))"
                )
                .font(.system(size: 12))
                .foregroundColor(.gray)
                
                Text("Quality: \(entry.sleepQuality)")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(entry.formattedSleepDuration)
                .font(
                    .system(
                        size: 17,
                        weight: .bold
                    )
                )
                .foregroundColor(.indigo)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(
            color: .black.opacity(0.05),
            radius: 5,
            x: 0,
            y: 2
        )
    }
    
    // MARK: - Time Formatter
    
    private func formattedTime(
        _ date: Date
    ) -> String {
        
        date.formatted(
            date: .omitted,
            time: .shortened
        )
    }
}

// MARK: - Preview

#Preview {
    
    NavigationStack {
        SleepView()
    }
    .modelContainer(
        for: SleepEntry.self,
        inMemory: true
    )
}
