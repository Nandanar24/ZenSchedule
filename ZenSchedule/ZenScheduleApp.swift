import SwiftUI
import SwiftData

@main
struct ZenScheduleApp: App {
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
        .modelContainer(
            for: [
                PlannerTask.self,
                SleepEntry.self
            ]
        )
    }
}
