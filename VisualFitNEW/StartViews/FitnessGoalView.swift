import SwiftUI

struct FitnessGoalView: View {
    @State private var selectedGoal: FitnessGoal = .weightLoss
    @State private var selectedValue: Int = 50 // Default value
    @State private var firstPartSubmitted = false
    @State private var showErrorAlert: Bool = false // For showing error alerts
    @State private var errorMessage: String = "" // To store error message
    @State private var isSubmitting: Bool = false // To manage button state
    @State private var showLogoutModal: Bool = false // For showing logout modal
    @State private var navigateToWelcomeView: Bool = false // Control navigation to welcome
    @State private var navigateToNextPage: Bool = false

    // Enum for fitness goals
    enum FitnessGoal: String {
        case weightLoss = "Weight Loss"
        case muscleGain = "Muscle Gain"
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    VStack(spacing: 40) {
                        // Title
                        Text("What is your fitness goal?")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.top, 40)

                        // Goal selection buttons (Weight Loss / Muscle Gain)
                        HStack(spacing: 40) {
                            // Weight Loss Button
                            Button(action: {
                                withAnimation {
                                    selectedGoal = .weightLoss
                                }
                            }) {
                                GoalSelectionView(iconName: "scalemass.fill", isSelected: selectedGoal == .weightLoss, label: "Weight Loss")
                            }

                            // Muscle Gain Button
                            Button(action: {
                                withAnimation {
                                    selectedGoal = .muscleGain
                                }
                            }) {
                                GoalSelectionView(iconName: "figure.strengthtraining.traditional", isSelected: selectedGoal == .muscleGain, label: "Muscle Gain")
                            }
                        }
                        .padding(.vertical, 20)

                        // Custom Horizontal Scroll Picker for Goal Value (0 to 100)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<101, id: \.self) { value in
                                    Text("\(value)")
                                        .font(.system(size: 30, weight: value == selectedValue ? .bold : .regular))
                                        .foregroundColor(value == selectedValue ? .yellow : .secondary)
                                        .onTapGesture {
                                            withAnimation {
                                                selectedValue = value
                                            }
                                        }
                                        .frame(width: 60, height: 80)
                                        .background(
                                            Circle()
                                                .fill(value == selectedValue ? Color.yellow.opacity(0.3) : Color.clear)
                                                .frame(width: 70, height: 70)
                                        )
                                }
                            }
                        }
                        .frame(height: 120)
                        .padding(.horizontal)

                        Button(action: {
                            sendToBackend()
                        }) {
                            Text(isSubmitting ? "Submitting..." : "Submit")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width * 0.85, height: 55)
                                .background(Color.yellow)
                                .cornerRadius(12)
                                .padding(.bottom, 20)
                                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .disabled(isSubmitting)

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.bottom, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color(.systemBackground).edgesIgnoringSafeArea(.bottom)).fullScreenCover(isPresented: $navigateToNextPage) {
                        MainView()
                            .navigationBarBackButtonHidden(true)
                    }

                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                showLogoutModal.toggle()
                            }) {
                                Image(systemName: "power")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .padding()
                            }
                        }
                        .background(Color.white)
                        .padding(.top)
                        Spacer()
                    }

                    if showLogoutModal {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showLogoutModal = false
                            }

                        LogoutModal(isPresented: $showLogoutModal) {
                            print("User logged out")
                            UserDefaults.standard.removeObject(forKey: "accessToken")
                            UserDefaults.standard.removeObject(forKey: "personalDetailsFlag")
                            UserDefaults.standard.removeObject(forKey: "isGoalSetForUser")
                            UserDefaults.standard.removeObject(forKey: "isFitnessGoalsSet")
                            navigateToWelcomeView = true
                        }
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height * 0.4)
                        .cornerRadius(12)
                        .transition(.move(edge: .bottom))
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .fullScreenCover(isPresented: $navigateToWelcomeView) {
            WelcomeView(
                isPersonalDetailsFilled: UserDefaults.standard.bool(forKey: "personalDetailsFlag") ?? false,
                isGoalSetForUser: UserDefaults.standard.bool(forKey: "isGoalSetForUser") ?? false,
                isFitnessGoalsSet: UserDefaults.standard.bool(forKey: "isFitnessGoalsSet") ?? false
            )
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    
    func sendToBackend() {
        let goalString = selectedGoal == .weightLoss ? "Weight Loss" : "Muscle Gain"
        let jsonData: [String: Any] = [
            "goal": goalString,
            "goalPriority": selectedValue
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: jsonData, options: []) else {
            errorMessage = "Failed to serialize data."
            showErrorAlert = true
            return
        }
        

        isSubmitting = true

        NetworkService.shared.postData(to: "http://localhost:4000/api/v1/updateFitnessGoalDetails", with: data) { (result: Result<UserGoalResponseModel, NetworkError>) in
            isSubmitting = false
            errorMessage = ""
            print("Sending req with \(data)")
            switch result {
            case .success(let response):
                if response.success {
                    print("Goal Updated:  \(response.message)")
                    UserDefaults.standard.set(true, forKey: "isFitnessGoalsSet")
                    navigateToNextPage = true;
                } else {
                    errorMessage = response.message
                    showErrorAlert = true
                }
            case .failure(let error):
                switch error {
                case .badURL:
                    errorMessage = "Invalid URL"
                case .requestFailed:
                    errorMessage = "Request failed"
                case .decodingFailed:
                    errorMessage = "Decoding failed"
                }
                showErrorAlert = true
            }
        }
    }
}

// Custom view for selecting fitness goals
struct GoalSelectionView: View {
    var iconName: String
    var isSelected: Bool
    var label: String

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.system(size: 50))
                .foregroundColor(isSelected ? .yellow : .secondary)
                .padding(.bottom, 5)

            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .yellow : .secondary)
        }
        .frame(width: 100, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(isSelected ? Color.yellow.opacity(0.1) : Color.clear)
        )
        .contentShape(Rectangle()) // For better touch area recognition
        .animation(.spring())
    }
}

// Preview
struct FitnessGoalView_Previews: PreviewProvider {
    static var previews: some View {
        FitnessGoalView()
            .preferredColorScheme(.light)
    }
}
