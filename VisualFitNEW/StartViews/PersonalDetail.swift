import SwiftUI

struct PersonalDetailsView: View {
    @State private var gender: String = "Male"
    @State private var height: String = "170"  // Default height in cm as String
    @State private var weight: String = "50"   // Default weight in kg as String
    @State private var showSetGoalView: Bool = false // Control navigation to SetGoalView
    @State private var showErrorAlert: Bool = false // For showing error alerts
    @State private var errorMessage: String = "" // To store error message
    @State private var isSubmitting: Bool = false // To manage button state
    @State private var showLogoutModal: Bool = false // For showing logout modal
    @State private var navigateToWelcomeView: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack(spacing: 30) {
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
                        
                        
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.yellow)

                        // Title and Subtitle
                        VStack(spacing: 8) {
                            Text("Personal Details")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Enter your personal details to get relevant insights.")
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }

                        // Form Section: Gender, Height, Weight
                        VStack(spacing: 20) {
                            // Gender Picker
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Gender")
                                    .foregroundColor(.white)
                                    .font(.headline)

                                Picker("Gender", selection: $gender) {
                                    Text("Male").tag("Male")
                                    Text("Female").tag("Female")
                                    Text("Other").tag("Other")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal, 10)
                                .background(Color.black.opacity(0.2))
                                .cornerRadius(10)
                            }

                            // Height Input
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Height (cm)")
                                    .foregroundColor(.white)
                                    .font(.headline)

                                TextField("Enter height", text: $height)
                                    .keyboardType(.numberPad)
                                    .onChange(of: height) { newValue in
                                        height = newValue.filter { $0.isNumber }
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.2))
                                    .cornerRadius(10)
                                    .foregroundColor(.yellow)
                                    .padding(.horizontal, 10)
                            }

                            // Weight Input
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Weight (kg)")
                                    .foregroundColor(.white)
                                    .font(.headline)

                                TextField("Enter weight", text: $weight)
                                    .keyboardType(.numberPad)
                                    .onChange(of: weight) { newValue in
                                        weight = newValue.filter { $0.isNumber }
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.2))
                                    .cornerRadius(10)
                                    .foregroundColor(.yellow)
                                    .padding(.horizontal, 10)
                            }
                        }
                        .padding(.horizontal, 20)

                        // Next Button
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
                    .fullScreenCover(isPresented: $showSetGoalView) {
                        SetGoalView()
                            .navigationBarBackButtonHidden(true)
                    }

                    // Logout Modal
                    if showLogoutModal {
                        Color.black.opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                showLogoutModal = false
                            }

                        LogoutModal(isPresented: $showLogoutModal) {
                            print("User logged out")
                            UserDefaults.standard.removeObject(forKey: "accessToken")
                            navigateToWelcomeView = true
                        }
                        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height * 0.4)
                    
                        .cornerRadius(12)
                        .transition(.move(edge: .bottom))
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }.fullScreenCover(isPresented: $navigateToWelcomeView) {
            WelcomeView()
        }
    }

    func sendToBackend() {
        guard !gender.isEmpty, !weight.isEmpty, !height.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        
        let jsonData: [String: Any] = [
            "gender": gender,
            "weight": weight,
            "height": height
        ]
        
        // Serialize to JSON data
        guard let data = try? JSONSerialization.data(withJSONObject: jsonData, options: []) else {
            errorMessage = "Failed to serialize data."
            return
        }

        isSubmitting = true // Start submitting

        // Call the network service to post the data
        NetworkService.shared.postData(to: "http://localhost:4000/api/v1/updatePersonalDetails", with: data) { (result: Result<PersonalDetailsUpdateModelResponse, NetworkError>) in
            isSubmitting = false // End submitting
            errorMessage = "" // Clear previous error
            switch result {
            case .success(let response):
                if response.success {
                    print("Details Updated:  \(response.message)")
                    UserDefaults.standard.set("true", forKey: "personalDetailsFlag")
                    showSetGoalView = true
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

struct PersonalDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDetailsView()
    }
}
