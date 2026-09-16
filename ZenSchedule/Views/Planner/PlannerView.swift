import SwiftUI
import SwiftData

struct PlannerView: View {

    // MARK: - SwiftData

    @Environment(\.modelContext) private var modelContext

    @Query(
        sort: \PlannerTask.date,
        order: .forward
    )
    private var tasks: [PlannerTask]

    // MARK: - Page State

    @State private var selectedDate = Date()
    @State private var showingAddTask = false

    // MARK: - Calendar

    private var calendar: Calendar {

        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar
    }

    // MARK: - Current Week

    private var currentWeek: [Date] {

        let dateComponents = calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear],
            from: selectedDate
        )

        guard let startOfWeek = calendar.date(
            from: dateComponents
        ) else {
            return []
        }

        return (0..<7).compactMap { dayNumber in

            calendar.date(
                byAdding: .day,
                value: dayNumber,
                to: startOfWeek
            )
        }
    }

    // MARK: - Selected Date Tasks

    private var tasksForSelectedDate: [PlannerTask] {

        tasks.filter { task in

            calendar.isDate(
                task.date,
                inSameDayAs: selectedDate
            )
        }
    }

    // MARK: - Upcoming Tasks

    private var upcomingTasks: [PlannerTask] {

        Array(
            tasks
                .filter { task in
                    task.date > Date() && !task.isCompleted
                }
                .prefix(3)
        )
    }

    // MARK: - Page Body

    var body: some View {

        ZStack {

            // MARK: Background

            Color(
                red: 0.99,
                green: 0.97,
                blue: 0.93
            )
            .ignoresSafeArea()

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 18
                ) {

                    // MARK: Header

                    plannerHeader

                    // MARK: Weekly Calendar

                    weeklyCalendar

                    // MARK: Selected Date Heading

                    Text(scheduleHeading)
                        .font(
                            .system(
                                size: 21,
                                weight: .bold
                            )
                        )

                    // MARK: Saved Tasks

                    selectedDateTasks

                    // MARK: Add Task Button

                    addTaskButton

                    // MARK: Upcoming

                    upcomingSection

                    Spacer()
                        .frame(height: 95)
                }
                .padding(.horizontal, 22)
                .padding(.top, 10)
            }

            // MARK: Bottom Navigation

            bottomNavigation
        }

        .sheet(isPresented: $showingAddTask) {

            AddTaskView(
                selectedDate: selectedDate
            )
        }
    }

    // MARK: - Header

    private var plannerHeader: some View {

        HStack {

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text("Planner")
                    .font(
                        .system(
                            size: 34,
                            weight: .bold
                        )
                    )

                Text(formattedSelectedDate)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
    }

    // MARK: - Weekly Calendar

    private var weeklyCalendar: some View {

        HStack {

            ForEach(
                currentWeek,
                id: \.self
            ) { date in

                Button {

                    selectedDate = date

                } label: {

                    CalendarDay(
                        date: date,
                        isSelected: calendar.isDate(
                            date,
                            inSameDayAs: selectedDate
                        ),
                        isToday: calendar.isDateInToday(date)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(
            color: .black.opacity(0.10),
            radius: 8,
            x: 0,
            y: 4
        )
    }

    // MARK: - Tasks for Selected Date

    @ViewBuilder
    private var selectedDateTasks: some View {

        VStack(spacing: 12) {

            if tasksForSelectedDate.isEmpty {

                VStack(spacing: 10) {

                    Image(
                        systemName: "calendar.badge.plus"
                    )
                    .font(.system(size: 32))
                    .foregroundColor(.gray)

                    Text("No tasks scheduled")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold
                            )
                        )

                    Text(
                        "Tap Add Task to plan something for this day."
                    )
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)

            } else {

                ForEach(tasksForSelectedDate) { task in

                    SwipeToDeleteTask {

                        TaskCard(
                            time: formattedTime(task.date),
                            period: formattedPeriod(task.date),
                            title: task.title,
                            subtitle: displayedSubtitle(for: task),
                            location: displayedLocation(for: task),
                            accentColor: colourForPriority(
                                task.priority
                            )
                        ) {

                            toggleCompletion(for: task)
                        }
                        .opacity(
                            task.isCompleted ? 0.55 : 1
                        )

                    } onDelete: {

                        deleteTask(task)
                    }

                    .contextMenu {

                        Button {

                            toggleCompletion(for: task)

                        } label: {

                            Label(
                                task.isCompleted
                                    ? "Mark Incomplete"
                                    : "Mark Complete",
                                systemImage: task.isCompleted
                                    ? "arrow.uturn.backward.circle"
                                    : "checkmark.circle"
                            )
                        }

                        Button(role: .destructive) {

                            deleteTask(task)

                        } label: {

                            Label(
                                "Delete Task",
                                systemImage: "trash"
                            )
                        }
                    }
                }
            }
        }
    }

    // MARK: - Add Task Button

    private var addTaskButton: some View {

        Button {

            showingAddTask = true

        } label: {

            Text("+ Add Task")
                .font(
                    .system(
                        size: 16,
                        weight: .bold
                    )
                )
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    Color(
                        red: 0.67,
                        green: 0.72,
                        blue: 0.95
                    )
                )
                .cornerRadius(14)
        }
    }

    // MARK: - Upcoming Section

    private var upcomingSection: some View {

        VStack(
            alignment: .leading,
            spacing: 12
        ) {

            HStack {

                Text("Upcoming")
                    .font(
                        .system(
                            size: 17,
                            weight: .semibold
                        )
                    )

                Spacer()

                Button("View All") {

                    print("View All tapped")
                }
                .font(.system(size: 12))
            }

            if upcomingTasks.isEmpty {

                Text("No upcoming tasks")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)

            } else {

                ForEach(upcomingTasks) { task in

                    UpcomingTaskCard(
                        task: task,
                        accentColor: colourForPriority(
                            task.priority
                        ),
                        completeAction: {

                            toggleCompletion(for: task)
                        },
                        deleteAction: {

                            deleteTask(task)
                        }
                    )
                }
            }
        }
    }

    // MARK: - Bottom Navigation

    private var bottomNavigation: some View {

        VStack {

            Spacer()

            HStack {

                NavigationItem(
                    icon: "house",
                    label: "Home",
                    isSelected: false
                )

                Spacer()

                NavigationItem(
                    icon: "calendar",
                    label: "Planner",
                    isSelected: true
                )

                Spacer()

                Button {

                    showingAddTask = true

                } label: {

                    Image(systemName: "plus")
                        .font(
                            .system(
                                size: 20,
                                weight: .bold
                            )
                        )
                        .foregroundColor(.white)
                        .frame(
                            width: 46,
                            height: 46
                        )
                        .background(
                            Color(
                                red: 0.67,
                                green: 0.72,
                                blue: 0.95
                            )
                        )
                        .clipShape(Circle())
                }

                Spacer()

                NavigationItem(
                    icon: "heart",
                    label: "Wellbeing",
                    isSelected: false
                )

                Spacer()

                NavigationItem(
                    icon: "person.fill",
                    label: "Profile",
                    isSelected: false
                )
            }
            .padding(.horizontal, 18)
            .padding(.top, 10)
            .padding(.bottom, 8)
            .background(Color.white)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Text Formatting

    private var formattedSelectedDate: String {

        selectedDate.formatted(
            .dateTime
                .weekday(.wide)
                .day()
                .month(.wide)
        )
    }

    private var scheduleHeading: String {

        if calendar.isDateInToday(selectedDate) {

            return "Today’s Schedule"
        }

        return selectedDate.formatted(
            .dateTime
                .weekday(.wide)
                .day()
                .month(.abbreviated)
        )
    }

    private func formattedTime(
        _ date: Date
    ) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"

        return formatter.string(from: date)
    }

    private func formattedPeriod(
        _ date: Date
    ) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "a"

        return formatter.string(from: date)
    }

    private func displayedSubtitle(
        for task: PlannerTask
    ) -> String {

        if !task.taskDescription.isEmpty {

            return task.taskDescription
        }

        if !task.subject.isEmpty {

            return task.subject
        }

        return "Scheduled task"
    }

    private func displayedLocation(
        for task: PlannerTask
    ) -> String {

        task.location.isEmpty
            ? "No location"
            : task.location
    }

    // MARK: - Priority Colours

    private func colourForPriority(
        _ priority: String
    ) -> Color {

        switch priority {

        case "High":
            return .red

        case "Low":
            return .green

        default:

            return Color(
                red: 0.45,
                green: 0.55,
                blue: 0.90
            )
        }
    }

    // MARK: - Task Actions

    private func toggleCompletion(
        for task: PlannerTask
    ) {

        task.isCompleted.toggle()

        saveChanges()
    }

    private func deleteTask(
        _ task: PlannerTask
    ) {

        modelContext.delete(task)

        saveChanges()
    }

    private func saveChanges() {

        do {

            try modelContext.save()

        } catch {

            print(
                "Could not save task changes: \(error)"
            )
        }
    }
}

// MARK: - Swipe To Delete Task

struct SwipeToDeleteTask<Content: View>: View {

    let content: Content
    let onDelete: () -> Void

    @State private var offset: CGFloat = 0

    private let deleteWidth: CGFloat = 90

    init(
        @ViewBuilder content: () -> Content,
        onDelete: @escaping () -> Void
    ) {

        self.content = content()
        self.onDelete = onDelete
    }

    var body: some View {

        ZStack(alignment: .trailing) {

            // MARK: Delete Button

            Button(role: .destructive) {

                withAnimation(.easeInOut(duration: 0.2)) {

                    offset = -400
                }

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + 0.2
                ) {

                    onDelete()
                }

            } label: {

                VStack(spacing: 5) {

                    Image(systemName: "trash.fill")
                        .font(.system(size: 18))

                    Text("Delete")
                        .font(
                            .system(
                                size: 11,
                                weight: .semibold
                            )
                        )
                }
                .foregroundColor(.white)
                .frame(width: deleteWidth)
                .frame(maxHeight: .infinity)
            }
            .background(Color.red)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 18
                )
            )

            // MARK: Task Content

            content
                .offset(x: offset)
                .gesture(

                    DragGesture(
                        minimumDistance: 15
                    )

                    .onChanged { value in

                        // Only allow a left swipe

                        if value.translation.width < 0 {

                            offset = max(
                                value.translation.width,
                                -deleteWidth
                            )
                        }
                    }

                    .onEnded { value in

                        withAnimation(
                            .spring(
                                response: 0.3,
                                dampingFraction: 0.8
                            )
                        ) {

                            // Open delete button if
                            // user swiped far enough

                            if value.translation.width < -45 {

                                offset = -deleteWidth

                            } else {

                                offset = 0
                            }
                        }
                    }
                )
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
    }
}

// MARK: - Calendar Day

struct CalendarDay: View {

    let date: Date
    let isSelected: Bool
    let isToday: Bool

    var body: some View {

        VStack(spacing: 7) {

            Text(
                date.formatted(
                    .dateTime.weekday(.abbreviated)
                )
                .uppercased()
            )
            .font(
                .system(
                    size: 9,
                    weight: .semibold
                )
            )
            .foregroundColor(
                isSelected
                    ? Color.blue
                    : Color.black
            )

            Text(
                date.formatted(
                    .dateTime.day()
                )
            )
            .font(
                .system(
                    size: 13,
                    weight: .medium
                )
            )
            .foregroundColor(
                isSelected
                    ? Color.white
                    : Color.black
            )
            .frame(
                width: 31,
                height: 31
            )
            .background(
                isSelected
                    ? Color(
                        red: 0.67,
                        green: 0.72,
                        blue: 0.95
                    )
                    : Color.clear
            )
            .clipShape(Circle())

            Circle()
                .fill(
                    isToday
                        ? Color.red.opacity(0.75)
                        : Color.clear
                )
                .frame(
                    width: 4,
                    height: 4
                )
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Upcoming Task Card

struct UpcomingTaskCard: View {

    let task: PlannerTask
    let accentColor: Color
    let completeAction: () -> Void
    let deleteAction: () -> Void

    var body: some View {

        HStack(spacing: 12) {

            VStack(spacing: 2) {

                Text(
                    task.date.formatted(
                        .dateTime.weekday(.abbreviated)
                    )
                    .uppercased()
                )
                .font(
                    .system(
                        size: 12,
                        weight: .bold
                    )
                )

                Text(
                    task.date.formatted(
                        .dateTime
                            .day()
                            .month(.abbreviated)
                    )
                    .uppercased()
                )
                .font(
                    .system(
                        size: 10,
                        weight: .semibold
                    )
                )
            }
            .frame(
                width: 58,
                height: 50
            )
            .background(
                accentColor.opacity(0.14)
            )
            .cornerRadius(14)

            Circle()
                .fill(accentColor)
                .frame(
                    width: 7,
                    height: 7
                )

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(task.title)
                    .font(
                        .system(
                            size: 14,
                            weight: .bold
                        )
                    )

                Text(
                    "Due \(task.date.formatted(date: .omitted, time: .shortened))"
                )
                .font(.system(size: 10))
                .foregroundColor(.gray)
            }

            Spacer()

            Button(action: completeAction) {

                Image(
                    systemName: task.isCompleted
                        ? "checkmark.circle.fill"
                        : "circle"
                )
                .font(.system(size: 20))
                .foregroundColor(
                    task.isCompleted
                        ? Color.green
                        : Color.gray.opacity(0.6)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(
            color: .black.opacity(0.08),
            radius: 6,
            x: 0,
            y: 3
        )
        .contextMenu {

            Button(action: completeAction) {

                Label(
                    task.isCompleted
                        ? "Mark Incomplete"
                        : "Mark Complete",
                    systemImage: task.isCompleted
                        ? "arrow.uturn.backward.circle"
                        : "checkmark.circle"
                )
            }

            Button(
                role: .destructive,
                action: deleteAction
            ) {

                Label(
                    "Delete Task",
                    systemImage: "trash"
                )
            }
        }
    }
}

// MARK: - Bottom Navigation Item

struct NavigationItem: View {

    let icon: String
    let label: String
    let isSelected: Bool

    var body: some View {

        VStack(spacing: 3) {

            Image(systemName: icon)
                .font(.system(size: 18))

            Text(label)
                .font(.system(size: 9))
        }
        .foregroundColor(
            isSelected
                ? .blue
                : .black
        )
    }
}

// MARK: - Preview

#Preview {

    NavigationStack {

        PlannerView()
    }
    .modelContainer(
        for: PlannerTask.self,
        inMemory: true
    )
}
