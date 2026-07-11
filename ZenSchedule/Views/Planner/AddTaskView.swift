import SwiftUI
import SwiftData

struct AddTaskView: View {
    
    // Gives this page access to SwiftData
    @Environment(\.modelContext) private var modelContext
    
    // Lets us close the Add Task page
    @Environment(\.dismiss) private var dismiss
    
    // Values entered by the user
    @State private var title = ""
    @State private var taskDescription = ""
    @State private var subject = ""
    @State private var location = ""
    @State private var selectedDate: Date
    @State private var priority = "Medium"
    
    private let priorities = [
        "Low",
        "Medium",
        "High"
    ]
    
    // The Planner page passes its selected date into this page
    init(selectedDate: Date = Date()) {
        _selectedDate = State(initialValue: selectedDate)
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // MARK: - Background
                
                Color(
                    red: 0.99,
                    green: 0.97,
                    blue: 0.93
                )
                .ignoresSafeArea()
                
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 22) {
                        
                        // MARK: - Heading
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Text("Add Task")
                                .font(.system(size: 32, weight: .bold))
                            
                            Text("Add a new task to your schedule.")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                        
                        // MARK: - Task Title
                        
                        FormField(
                            heading: "Task title",
                            placeholder: "e.g. Calculus practice",
                            text: $title
                        )
                        
                        // MARK: - Description
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Description")
                                .font(.system(size: 15, weight: .semibold))
                            
                            TextField(
                                "Add some details",
                                text: $taskDescription,
                                axis: .vertical
                            )
                            .lineLimit(3...6)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                        }
                        
                        // MARK: - Subject
                        
                        FormField(
                            heading: "Subject or category",
                            placeholder: "e.g. Calculus",
                            text: $subject
                        )
                        
                        // MARK: - Location
                        
                        FormField(
                            heading: "Location",
                            placeholder: "e.g. Library",
                            text: $location
                        )
                        
                        // MARK: - Date and Time
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Date and time")
                                .font(.system(size: 15, weight: .semibold))
                            
                            DatePicker(
                                "Choose date and time",
                                selection: $selectedDate,
                                displayedComponents: [
                                    .date,
                                    .hourAndMinute
                                ]
                            )
                            .datePickerStyle(.compact)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(16)
                        }
                        
                        // MARK: - Priority
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("Priority")
                                .font(.system(size: 15, weight: .semibold))
                            
                            Picker(
                                "Priority",
                                selection: $priority
                            ) {
                                
                                ForEach(priorities, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        // MARK: - Save Button
                        
                        Button {
                            saveTask()
                        } label: {
                            
                            Text("Save Task")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(
                                    titleIsValid
                                    ? Color(
                                        red: 0.67,
                                        green: 0.72,
                                        blue: 0.95
                                    )
                                    : Color.gray.opacity(0.5)
                                )
                                .cornerRadius(16)
                        }
                        .disabled(!titleIsValid)
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 20)
                }
            }
            
            // MARK: - Navigation Buttons
            
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Validation
    
    private var titleIsValid: Bool {
        !title.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }
    
    // MARK: - Save Task
    
    private func saveTask() {
        
        let newTask = PlannerTask(
            title: title.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            taskDescription: taskDescription,
            date: selectedDate,
            subject: subject,
            location: location,
            priority: priority,
            isCompleted: false
        )
        
        modelContext.insert(newTask)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save task: \(error)")
        }
    }
}

// MARK: - Reusable Form Field

struct FormField: View {
    
    let heading: String
    let placeholder: String
    
    @Binding var text: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text(heading)
                .font(.system(size: 15, weight: .semibold))
            
            TextField(
                placeholder,
                text: $text
            )
            .padding()
            .background(Color.white)
            .cornerRadius(16)
        }
    }
}

#Preview {
    AddTaskView()
        .modelContainer(
            for: PlannerTask.self,
            inMemory: true
        )
}
