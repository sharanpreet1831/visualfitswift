import SwiftUI

struct SetGoalView: View {
    @State private var selectedGoal: Int = 3 // Default selected value
    @State private var showFitnessGoalView: Bool = false // Control navigation to FitnessGoalView
    @State private var showErrorAlert: Bool = false // For showing error alerts
    @State private var errorMessage: String = "" // To store error message
    @State private var isSubmitting: Bool = false // To manage button state
    @State private var showLogoutModal: Bool = false // For showing logout modal
    @State private var navigateToWelcomeView: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack(spacing: 50) {
                        HStack {
                            Spacer()
                            Button(action: {
                                showLogoutModal.toggle()
                            }) {
                                Image(systemName: "power")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .background(Color.black.opacity(0.7))
                        .padding(.top)

                        // Goal Icon
                        Image(systemName: "target")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.yellow)

                        // Title and Subtitle
                        VStack(spacing: 8) {
                            Text("Set your Goal")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Tell us how often would you like to exercise in a week")
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }

                        // Scroll Picker for Goal Selection
                        Picker("Goal", selection: $selectedGoal) {
                            ForEach(2...7, id: \.self) { value in
                                Text("\(value)")
                                    .font(.title)
                                    .foregroundColor(value == selectedGoal ? .yellow : .gray)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 150)

                        Button(action: sendToBackend) {
                            Text(isSubmitting ? "Submitting..." : "Next")
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(color: Color.yellow.opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                        .padding(.horizontal, 20)
                        .disabled(isSubmitting)

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                        }

                        Spacer()
                    }
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                    .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }
                    .fullScreenCover(isPresented: $showFitnessGoalView) {
                        FitnessGoalView()
                            .navigationBarBackButtonHidden(true)
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
    }


    func sendToBackend() {
        let jsonData: [String: Any] = [
            "days": selectedGoal
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: jsonData, options: []) else {
            errorMessage = "Failed to serialize data."
            return
        }

        isSubmitting = true

        NetworkService.shared.postData(to: "http://localhost:4000/api/v1/updateGoalDetails", with: data) { (result: Result<UserGoalResponseModel, NetworkError>) in
            isSubmitting = false
            errorMessage = ""
            switch result {
            case .success(let response):
                if response.success {
                    print("Details Updated:  \(response.message)")
                    UserDefaults.standard.set(true, forKey: "isGoalSetForUser")
                    showFitnessGoalView = true
                } else {
                    errorMessage = response.message
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
            }
        }
    }
}

struct SetGoalView_Previews: PreviewProvider {
    static var previews: some View {
        SetGoalView()
    }
}
