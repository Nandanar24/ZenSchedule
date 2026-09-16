import SwiftUI
import SwiftData

@main
struct ZenScheduleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(
            for: [
                PlannerTask.self,
                SleepEntry.self
            ]
        )
    }
}
