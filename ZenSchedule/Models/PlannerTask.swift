import Foundation
import SwiftData

@Model
final class PlannerTask {

    var title: String
    var taskDescription: String
    var date: Date
    var subject: String
    var location: String
    var priority: String
    var isCompleted: Bool

    init(
        title: String,
        taskDescription: String = "",
        date: Date,
        subject: String = "",
        location: String = "",
        priority: String = "Medium",
        isCompleted: Bool = false
    ) {
        self.title = title
        self.taskDescription = taskDescription
        self.date = date
        self.subject = subject
        self.location = location
        self.priority = priority
        self.isCompleted = isCompleted
    }
}
