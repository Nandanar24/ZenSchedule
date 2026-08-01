import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        
        ZStack {
            
            // MARK: - Background Colour
            
            Color(red: 0.99, green: 0.96, blue: 0.92)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer()
                
                // MARK: - Main Image
                
                Image("WelcomeIllustration")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 170)
                
                // MARK: - App Title
                
                Text("ZenSchedule")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(.black)
                
                // MARK: - Subheading
                
                Text("Your student planner for\na healthier, more balanced life.")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                // MARK: - Divider
                
                HStack(spacing: 16) {
                    
                    Rectangle()
                        .fill(Color.red.opacity(0.7))
                        .frame(width: 100, height: 1)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                    
                    Rectangle()
                        .fill(Color.red.opacity(0.7))
                        .frame(width: 100, height: 1)
                }
                .padding(.vertical, 8)
                
                // MARK: - Motto
                
                Text("Plan your day.\nTrack your wellbeing.\nStay balanced.")
                    .font(.system(size: 20, weight: .medium))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 10)
                
                // MARK: - Feature Cards
                
                VStack(spacing: 14) {
                    
                    // MARK: Planner Card
                    
                    NavigationLink {
                        PlannerView()
                    } label: {
                        FeatureCard(
                            title: "Planner",
                            description: "Organise your classes, assignments and more.",
                            icon: "calendar",
                            color: Color(
                                red: 0.85,
                                green: 0.92,
                                blue: 0.98
                            )
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // MARK: Sleep Card

                    NavigationLink {
                        SleepView()
                    } label: {
                        FeatureCard(
                            title: "Sleep & Stress",
                            description: "Track your sleep, stress levels and daily mood.",
                            icon: "moon.zzz.fill",
                            color: Color(
                                red: 0.82,
                                green: 0.93,
                                blue: 0.91
                            )
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // MARK: AI Card
                    
                    FeatureCard(
                        title: "AI Wellbeing Assistant",
                        description: "Get personalised tips and support to feel your best.",
                        icon: "sparkles",
                        color: Color(
                            red: 0.98,
                            green: 0.91,
                            blue: 0.92
                        )
                    )
                }
                .padding(.top, 25)
                
                Spacer()
                
                // MARK: - Footer
                
                Text("✨ Small steps today, better you tomorrow ✨")
                    .font(.system(size: 14))
                    .foregroundColor(.black.opacity(0.65))
                    .padding(.bottom, 14)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
