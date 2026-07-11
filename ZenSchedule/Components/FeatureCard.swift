import SwiftUI

struct FeatureCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {

            // MARK: - Icon

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.45))
                    .frame(width: 56, height: 56)

                Image(systemName: icon)
                    .font(.system(size: 25))
                    .foregroundColor(.black.opacity(0.65))
            }

            // MARK: - Text

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)

                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }

            Spacer()

            // MARK: - Chevron

            Image(systemName: "chevron.right")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black.opacity(0.45))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color)
        .cornerRadius(22)
        .contentShape(Rectangle())
    }
}

#Preview {
    FeatureCard(
        title: "Planner",
        description: "Organise your classes, assignments, activities and more.",
        icon: "calendar",
        color: Color(red: 0.85, green: 0.92, blue: 0.98)
    )
    .padding()
}
