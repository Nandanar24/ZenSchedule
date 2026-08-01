import SwiftUI
import SwiftData

struct AddSleepEntryView: View {
    
    // MARK: - SwiftData
    
    // Gives this screen access to the app's saved data
    @Environment(\.modelContext) private var modelContext
    
    // Lets this screen close after Cancel or Save
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - User Input
    
    // Default bedtime: 10:30 PM today
    @State private var bedtime = Calendar.current.date(
        bySettingHour: 22,
        minute: 30,
        second: 0,
        of: Date()
    ) ?? Date()
    
    // Default wake-up time: 7:00 AM tomorrow
    @State private var wakeUpTime = Calendar.current.date(
        bySettingHour: 7,
        minute: 0,
        second: 0,
        of: Date().addingTimeInterval(86_400)
    ) ?? Date()
    
    @State private var sleepQuality = "Good"
    @State private var stressLevel = 5.0
    @State private var energyLevel = 5.0
    @State private var notes = ""
    
    // Options shown inside the sleep quality picker
    private let sleepQualityOptions = [
        "Poor",
        "Fair",
        "Good",
        "Excellent"
    ]
    
    // MARK: - Page
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // MARK: - Background
                
                Color(
                    red: 0.96,
                    green: 0.97,
                    blue: 1.00
                )
                .ignoresSafeArea()
                
                // MARK: - Scrollable Content
                
                ScrollView(.vertical, showsIndicators: true) {
                    
                    VStack(
                        alignment: .leading,
                        spacing: 20
                    ) {
                        
                        // MARK: - Header
                        
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.indigo)
                        
                        Text("Log Sleep")
                            .font(
                                .system(
                                    size: 32,
                                    weight: .bold
                                )
                            )
                        
                        Text("Record your sleep and wellbeing.")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                        
                        // MARK: - Bedtime
                        
                        SleepInputCard(
                            title: "Bedtime",
                            icon: "moon.fill"
                        ) {
                            
                            DatePicker(
                                "Select bedtime",
                                selection: $bedtime,
                                displayedComponents: [
                                    .date,
                                    .hourAndMinute
                                ]
                            )
                            .datePickerStyle(.compact)
                        }
                        
                        // MARK: - Wake-up Time
                        
                        SleepInputCard(
                            title: "Wake-up Time",
                            icon: "sun.max.fill"
                        ) {
                            
                            DatePicker(
                                "Select wake-up time",
                                selection: $wakeUpTime,
                                displayedComponents: [
                                    .date,
                                    .hourAndMinute
                                ]
                            )
                            .datePickerStyle(.compact)
                        }
                        
                        // MARK: - Total Sleep
                        
                        SleepInputCard(
                            title: "Total Sleep",
                            icon: "clock.fill"
                        ) {
                            
                            Text(formattedSleepDuration)
                                .font(
                                    .system(
                                        size: 26,
                                        weight: .bold
                                    )
                                )
                                .foregroundColor(.indigo)
                        }
                        
                        // MARK: - Sleep Quality
                        
                        SleepInputCard(
                            title: "Sleep Quality",
                            icon: "star.fill"
                        ) {
                            
                            Picker(
                                "Sleep Quality",
                                selection: $sleepQuality
                            ) {
                                
                                ForEach(
                                    sleepQualityOptions,
                                    id: \.self
                                ) { option in
                                    
                                    Text(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // MARK: - Stress Level
                        
                        SleepInputCard(
                            title: "Stress Level: \(Int(stressLevel))/10",
                            icon: "brain.head.profile"
                        ) {
                            
                            Slider(
                                value: $stressLevel,
                                in: 1...10,
                                step: 1
                            )
                            .tint(.indigo)
                        }
                        
                        // MARK: - Energy Level
                        
                        SleepInputCard(
                            title: "Energy Level: \(Int(energyLevel))/10",
                            icon: "bolt.fill"
                        ) {
                            
                            Slider(
                                value: $energyLevel,
                                in: 1...10,
                                step: 1
                            )
                            .tint(.yellow)
                        }
                        
                        // MARK: - Notes
                        
                        VStack(
                            alignment: .leading,
                            spacing: 8
                        ) {
                            
                            Text("Notes")
                                .font(
                                    .system(
                                        size: 15,
                                        weight: .semibold
                                    )
                                )
                            
                            TextField(
                                "How did you sleep?",
                                text: $notes,
                                axis: .vertical
                            )
                            .lineLimit(3...6)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                        }
                        
                        // MARK: - Save Button
                        
                        Button {
                            saveSleepEntry()
                        } label: {
                            
                            Text("Save Sleep Entry")
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
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 20)
                    
                    // Extra room at the bottom makes scrolling easier
                    .padding(.bottom, 120)
                }
                
                // Hides the keyboard when the user scrolls
                .scrollDismissesKeyboard(.interactively)
            }
            
            // MARK: - Cancel Button
            
            .toolbar {
                
                ToolbarItem(
                    placement: .cancellationAction
                ) {
                    
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Sleep Duration Calculation
    
    private var totalSleepMinutes: Int {
        
        let difference = wakeUpTime.timeIntervalSince(
            bedtime
        )
        
        return max(
            Int(difference / 60),
            0
        )
    }
    
    private var formattedSleepDuration: String {
        
        let hours = totalSleepMinutes / 60
        let minutes = totalSleepMinutes % 60
        
        return "\(hours)h \(minutes)m"
    }
    
    // MARK: - Save Sleep Entry
    
    private func saveSleepEntry() {
        
        let newEntry = SleepEntry(
            bedtime: bedtime,
            wakeUpTime: wakeUpTime,
            sleepQuality: sleepQuality,
            stressLevel: stressLevel,
            energyLevel: energyLevel,
            notes: notes
        )
        
        modelContext.insert(newEntry)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save sleep entry: \(error)")
        }
    }
}

// MARK: - Reusable Sleep Input Card

struct SleepInputCard<Content: View>: View {
    
    let title: String
    let icon: String
    let content: Content
    
    init(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            
            // MARK: - Card Heading
            
            HStack(spacing: 8) {
                
                Image(systemName: icon)
                    .foregroundColor(.indigo)
                
                Text(title)
                    .font(
                        .system(
                            size: 15,
                            weight: .semibold
                        )
                    )
            }
            
            // MARK: - Card Content
            
            content
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(
            color: .black.opacity(0.06),
            radius: 6,
            x: 0,
            y: 3
        )
    }
}

// MARK: - Preview

#Preview {
    
    AddSleepEntryView()
        .modelContainer(
            for: SleepEntry.self,
            inMemory: true
        )
}
