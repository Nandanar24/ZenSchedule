
import SwiftUI
import SwiftData
struct AIView: View {
// MARK: - Saved Data
@Query(sort: \SleepEntry.createdAt, order: .reverse)
    private var sleepEntries: [SleepEntry]
@Query(sort: \PlannerTask.date, order: .forward)
    private var tasks: [PlannerTask]
// MARK: - Colours
private let backgroundColour = Color(
        red: 0.99,
        green: 0.96,
        blue: 0.92
    )
private let softGreen = Color(
        red: 0.91,
        green: 0.95,
        blue: 0.91
    )
private let softPink = Color(
        red: 0.99,
        green: 0.91,
        blue: 0.92
    )
private let softBlue = Color(
        red: 0.90,
        green: 0.95,
        blue: 0.99
    )
private let softPurple = Color(
        red: 0.94,
        green: 0.91,
        blue: 0.98
    )
// MARK: - Data
private var latestSleepEntry: SleepEntry? {
        sleepEntries.first
    }
private var todaysTasks: [PlannerTask] {
        tasks.filter { task in
            Calendar.current.isDateInToday(task.date)
        }
    }
private var unfinishedTasks: [PlannerTask] {
        todaysTasks.filter { !$0.isCompleted }
    }
private var highPriorityTasks: [PlannerTask] {
        unfinishedTasks.filter { task in
            task.priority == "High"
        }
    }
// MARK: - Readiness Score
private var readinessScore: Int {
guard let sleep = latestSleepEntry else {
            return 0
        }
var score = 100
// Sleep
        if sleep.totalSleepMinutes < 360 {
            score -= 30
        } else if sleep.totalSleepMinutes < 420 {
            score -= 20
        } else if sleep.totalSleepMinutes < 480 {
            score -= 10
        }
// Stress
        if sleep.stressLevel >= 8 {
            score -= 25
        } else if sleep.stressLevel >= 6 {
            score -= 15
        } else if sleep.stressLevel >= 4 {
            score -= 5
        }
// Energy
        if sleep.energyLevel <= 2 {
            score -= 20
        } else if sleep.energyLevel <= 4 {
            score -= 10
        }
// Workload
        if unfinishedTasks.count >= 6 {
            score -= 15
        } else if unfinishedTasks.count >= 4 {
            score -= 10
        }
if highPriorityTasks.count >= 3 {
            score -= 10
        }
return max(0, min(score, 100))
    }
// MARK: - Readiness Text
private var readinessTitle: String {
if latestSleepEntry == nil {
            return "Add your wellbeing data"
        }
if readinessScore >= 80 {
            return "Looking good"
        } else if readinessScore >= 60 {
            return "Take it steady"
        } else if readinessScore >= 40 {
            return "Go easy today"
        } else {
            return "Prioritise rest"
        }
    }
private var readinessMessage: String {
guard latestSleepEntry != nil else {
            return "Record your sleep and stress first so ZenSchedule can create your personalised overview."
        }
if readinessScore >= 80 {
            return "Your sleep, stress and workload look balanced. You're in a good place to continue with your planned day."
        } else if readinessScore >= 60 {
            return "Your wellbeing looks fairly balanced, but give yourself breaks and focus on your most important work first."
        } else if readinessScore >= 40 {
            return "Your sleep, stress or workload may make today more demanding. Focus on essential tasks and reduce lower-priority work where possible."
        } else {
            return "Your wellbeing information suggests a lighter day may be helpful. Prioritise essential work, breaks and rest."
        }
    }
// MARK: - Main View
var body: some View {
ZStack {
backgroundColour
                .ignoresSafeArea()
ScrollView {
VStack(alignment: .leading, spacing: 22) {
header
readinessCard
summaryCards
todaysPlan
suggestionCard
disclaimer
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Zen Assistant")
        .navigationBarTitleDisplayMode(.inline)
    }
// MARK: - Header
private var header: some View {
VStack(alignment: .leading, spacing: 7) {
HStack {
Image(systemName: "sparkles")
                    .foregroundColor(.pink)
Text("YOUR DAILY CHECK-IN")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
Spacer()
            }
Text("How are we looking today?")
                .font(.system(size: 29, weight: .bold))
Text("Here's your personalised overview based on your wellbeing and workload.")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 15)
    }
// MARK: - Readiness Card
private var readinessCard: some View {
VStack(alignment: .leading, spacing: 18) {
HStack {
Text("TODAY'S READINESS")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
Spacer()
Text(Date.now.formatted(
                    .dateTime.day().month(.abbreviated)
                ))
                .font(.caption)
                .foregroundColor(.secondary)
            }
HStack(spacing: 20) {
ZStack {
Circle()
                        .stroke(
                            Color.white.opacity(0.8),
                            lineWidth: 10
                        )
Circle()
                        .trim(
                            from: 0,
                            to: CGFloat(readinessScore) / 100
                        )
                        .stroke(
                            Color.green.opacity(0.65),
                            style: StrokeStyle(
                                lineWidth: 10,
                                lineCap: .round
                            )
                        )
                        .rotationEffect(.degrees(-90))
Text("\(readinessScore)%")
                        .font(.system(size: 25, weight: .bold))
                }
                .frame(width: 100, height: 100)
VStack(alignment: .leading, spacing: 8) {
HStack {
Image(systemName: readinessIcon)
                            .foregroundColor(.green)
Text(readinessTitle)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
Text(readinessMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )
                }
            }
        }
        .padding(20)
        .background(softGreen)
        .clipShape(
            RoundedRectangle(cornerRadius: 25)
        )
    }
private var readinessIcon: String {
if readinessScore >= 80 {
            return "leaf.fill"
        } else if readinessScore >= 60 {
            return "sun.max.fill"
        } else if readinessScore >= 40 {
            return "cloud.sun.fill"
        } else {
            return "moon.stars.fill"
        }
    }
// MARK: - Summary Cards
private var summaryCards: some View {
HStack(spacing: 10) {
summaryCard(
                icon: "moon.stars.fill",
                value: latestSleepEntry?.formattedSleepDuration ?? "--",
                title: "Sleep",
                colour: softBlue
            )
summaryCard(
                icon: "brain.head.profile",
                value: stressValue,
                title: "Stress",
                colour: softPink
            )
summaryCard(
                icon: "checklist",
                value: "\(unfinishedTasks.count)",
                title: "Tasks",
                colour: softPurple
            )
        }
    }
private func summaryCard(
        icon: String,
        value: String,
        title: String,
        colour: Color
    ) -> some View {
VStack(spacing: 10) {
Image(systemName: icon)
                .font(.system(size: 25))
                .foregroundColor(.black.opacity(0.65))
Text(value)
                .font(.system(size: 20, weight: .bold))
Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(colour)
        .clipShape(
            RoundedRectangle(cornerRadius: 22)
        )
    }
private var stressValue: String {
guard let sleep = latestSleepEntry else {
            return "--"
        }
return "\(Int(sleep.stressLevel))/10"
    }
// MARK: - Today's Plan
private var todaysPlan: some View {
VStack(alignment: .leading, spacing: 17) {
HStack {
Image(systemName: "sparkles")
                    .foregroundColor(.pink)
Text("Your plan for today")
                    .font(.title3)
                    .fontWeight(.bold)
Spacer()
Text("\(unfinishedTasks.count) tasks")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
if unfinishedTasks.isEmpty {
VStack(spacing: 10) {
Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.green)
Text("You're all caught up!")
                        .fontWeight(.semibold)
Text("You have no unfinished tasks scheduled for today.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
} else {
ForEach(
                    Array(unfinishedTasks.prefix(3).enumerated()),
                    id: \.element.id
                ) { index, task in
taskRow(
                        number: index + 1,
                        task: task
                    )
if index < min(unfinishedTasks.count, 3) - 1 {
                        Divider()
                    }
                }
if unfinishedTasks.count > 3 {
Text("+ \(unfinishedTasks.count - 3) more tasks")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.75))
        .clipShape(
            RoundedRectangle(cornerRadius: 25)
        )
    }
// MARK: - Task Row
private func taskRow(
        number: Int,
        task: PlannerTask
    ) -> some View {
HStack(spacing: 14) {
ZStack {
Circle()
                    .fill(priorityColour(task.priority).opacity(0.15))
Text("\(number)")
                    .fontWeight(.semibold)
                    .foregroundColor(
                        priorityColour(task.priority)
                    )
            }
            .frame(width: 40, height: 40)
VStack(alignment: .leading, spacing: 4) {
Text(task.title)
                    .fontWeight(.semibold)
Text("\(task.priority) priority")
                    .font(.caption)
                    .foregroundColor(
                        priorityColour(task.priority)
                    )
            }
Spacer()
Text(
                task.date.formatted(
                    date: .omitted,
                    time: .shortened
                )
            )
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }
private func priorityColour(
        _ priority: String
    ) -> Color {
switch priority {
case "High":
            return .red
case "Medium":
            return .orange
case "Low":
            return .green
default:
            return .gray
        }
    }
// MARK: - Suggestion
private var suggestionCard: some View {
VStack(alignment: .leading, spacing: 12) {
HStack {
Image(systemName: "lightbulb.fill")
                    .foregroundColor(.pink)
Text("Suggestion")
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
            }
Text(personalisedSuggestion)
                .font(.system(size: 15))
                .lineSpacing(4)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(softPink.opacity(0.75))
        .clipShape(
            RoundedRectangle(cornerRadius: 22)
        )
    }
// MARK: - Recommendation Logic
private var personalisedSuggestion: String {
guard let sleep = latestSleepEntry else {
return """
            Add a sleep and stress entry to receive a personalised suggestion for today.
            """
        }
let sleepMinutes = sleep.totalSleepMinutes
        let stress = sleep.stressLevel
        let energy = sleep.energyLevel
// Very low sleep
        if sleepMinutes < 360 {
if !highPriorityTasks.isEmpty {
return """
                You recorded less than 6 hours of sleep. Focus on your high-priority work first and consider moving lower-priority tasks to another day if possible.
                """
            }
return """
            You recorded less than 6 hours of sleep. Consider keeping today's workload lighter and taking regular breaks.
            """
        }
// High stress
        if stress >= 8 {
return """
            Your stress level is high today. Focus on one task at a time, start with your most important work and give yourself short breaks between study blocks.
            """
        }
// Low energy
        if energy <= 3 {
return """
            Your energy level is lower today. Start with your most important task while you have the most energy and avoid overloading your schedule.
            """
        }
// Heavy workload
        if unfinishedTasks.count >= 5 {
return """
            You have a busy schedule today. Prioritise your high-priority tasks first and break larger pieces of work into smaller, manageable steps.
            """
        }
// Multiple important tasks
        if highPriorityTasks.count >= 2 {
return """
            You have multiple high-priority tasks today. Work through them in order of importance before moving on to lower-priority tasks.
            """
        }
// Balanced day
        return """
        Your wellbeing and workload look manageable today. Continue with your planned tasks and remember to take breaks between focused work periods.
        """
    }
// MARK: - Disclaimer
private var disclaimer: some View {
Text(
            "ZenSchedule provides general wellbeing suggestions based on the information you record. It is not medical advice."
        )
        .font(.caption2)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 15)
    }
}

