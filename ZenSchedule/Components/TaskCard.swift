import SwiftUI

struct TaskCard: View {
    
    let time: String
    let period: String
    let title: String
    let subtitle: String
    let location: String
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            
            HStack(spacing: 14) {
                
                // MARK: - Time Box
                
                VStack(spacing: 2) {
                    Text(time)
                        .font(.system(size: 15, weight: .semibold))
                    
                    Text(period)
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(accentColor)
                .frame(width: 62, height: 62)
                .background(accentColor.opacity(0.14))
                .cornerRadius(16)
                
                // MARK: - Task Information
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(subtitle)
                        .font(.system(size: 11))
                        .foregroundColor(.black.opacity(0.72))
                    
                    HStack(spacing: 5) {
                        Circle()
                            .fill(accentColor)
                            .frame(width: 6, height: 6)
                        
                        Text(location)
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // MARK: - Edit Icon
                
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.black)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(
                color: .black.opacity(0.10),
                radius: 7,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TaskCard(
        time: "9:00",
        period: "AM",
        title: "Mathematics",
        subtitle: "Algebra – Practice questions",
        location: "Room 12",
        accentColor: .blue
    ) {
        print("Maths tapped")
    }
    .padding()
    
}
