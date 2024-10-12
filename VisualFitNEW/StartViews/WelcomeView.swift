import SwiftUI

struct WelcomeView: View {
    @Environment(\.colorScheme) var colorScheme
    let isPersonalDetailsFilled: Bool
    let isGoalSetForUser: Bool
    let isFitnessGoalsSet: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var navigateToNextPage = false  // State to trigger navigation
    @State private var errorMessage: String?       // State to store error message
    @State private var isLoading = false           // State to show a loading indicator
    @State private var navigateToSignUpPage = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.9)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack(spacing: 40) {
                    Spacer()

                    // Logo with Overlay Text
                    ZStack {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 120, height: 120)

                        Text("VF")
                            .font(.system(size: 50, weight: .heavy))
                            .foregroundColor(.black)
                    }
                    .shadow(radius: 10)

                    // Titles and Subtitle
                    VStack(spacing: 8) {
                        Text("Welcome to")
                            .font(.title3)
                            .foregroundColor(.white.opacity(1))

                        Text("VisualFit")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.yellow)
                            .shadow(radius: 5)

                        Text("A fitness companion to help you achieve your dream body")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }

                    Spacer()

                    // Text Fields for Email and Password
                    VStack(spacing: 16) {
                        ZStack(alignment: .leading) {
                            // Placeholder Text
                            if username.isEmpty {
                                Text("Username or Email")
                                    .foregroundColor(Color.white.opacity(1)) // Custom placeholder color
                                    .padding(.leading, 5) // Aligning with text field padding
                            }
                            // Actual TextField

                            TextField("", text: $username)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                )
                        }
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("Password")
                                    .foregroundColor(Color.white.opacity(1)) // Placeholder color
                                    .padding(.leading, 5) // Aligning with text field padding
                            }
                            SecureField("", text: $password)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)

                    // Sign In Button
                    Button(action: signInWithEmail) {
                        Text("Sign In")
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
                    
                    Button(action: {
                        navigateToSignUpPage = true
                    }) {
                        Text("Sign Up")
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
                    .padding(.horizontal, 20).fullScreenCover(isPresented: $navigateToSignUpPage) {
                        SignUpView() 
                    }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    if isLoading {
                        ProgressView()
                    }
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $navigateToNextPage) {
                determineNextView()
            }
        }
    }

    private func signInWithEmail() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required."
            return
        }

        // Prepare the data you need to send to your API
        let jsonData: [String: Any] = [
            "email": username.lowercased(),
            "password": password.lowercased()
        ]

        // Serialize to JSON data
        guard let data = try? JSONSerialization.data(withJSONObject: jsonData, options: []) else {
            errorMessage = "Failed to serialize data."
            return
        }

        isLoading = true

        // Call the network service to post the data
        NetworkService.shared.postData(to: "http://localhost:4000/api/v1/sign-in", with: data) { (result: Result<LoginResponse, NetworkError>) in
            isLoading = false
            errorMessage = nil
            switch result {
            case .success(let response):
                if response.success {
                    print("Response: \(response)")
                    print("Login successful: \(response.message)")
                    UserDefaults.standard.set(response.token, forKey: "accessToken")
                    UserDefaults.standard.set(response.user?.isPersonalDetailsSet, forKey: "personalDetailsFlag")
                    UserDefaults.standard.set(response.user?.isGoalSet,forKey: "isGoalSetForUser")
                    UserDefaults.standard.set(response.user?.isFitnessGoalSet,forKey: "isFitnessGoalsSet")
                    UserDefaults.standard.set(response.user?.avatar,forKey: "profilePicture")
                    UserDefaults.standard.set(response.user?.name,forKey: "name")
                    UserDefaults.standard.set(response.user?.email,forKey: "email")
                    navigateToNextPage = true
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

    private func determineNextView() -> some View {
        let isPersonalDetailsFilled = UserDefaults.standard.bool(forKey: "personalDetailsFlag")
        let isGoalSetForUser = UserDefaults.standard.bool(forKey: "isGoalSetForUser")
        let isFitnessGoalsSet = UserDefaults.standard.bool(forKey: "isFitnessGoalsSet")
        
        if isPersonalDetailsFilled != true {
            return AnyView(PersonalDetailsView().navigationBarBackButtonHidden(true))
        } else if isGoalSetForUser != true {
            return AnyView(SetGoalView().navigationBarBackButtonHidden(true))
        } else if isFitnessGoalsSet != true {
            return AnyView(FitnessGoalView().navigationBarBackButtonHidden(true))
        } else {
            return AnyView(MainView())
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(
            isPersonalDetailsFilled: UserDefaults.standard.bool(forKey: "personalDetailsFlag") ?? false,
            isGoalSetForUser: UserDefaults.standard.bool(forKey: "isGoalSetForUser") ?? false,
            isFitnessGoalsSet: UserDefaults.standard.bool(forKey: "isFitnessGoalsSet") ?? false
        ).preferredColorScheme(.dark)
    }
}
