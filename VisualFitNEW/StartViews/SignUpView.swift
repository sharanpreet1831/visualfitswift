import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var fullName: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var navigateToWelcomePage = false
    @State private var errorMessage: String?
    @State private var isLoading = false
    
    var body: some View {
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
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.yellow)
                        .shadow(radius: 5)
                    
                    Text("Join VisualFit and start your fitness journey!")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Text Fields for Full Name, Username, Email, Password, and Confirm Password
                VStack(spacing: 16) {
                    ZStack(alignment: .leading) {
                        if fullName.isEmpty {
                            Text("Full Name")
                                .foregroundColor(Color.white.opacity(1))
                                .padding(.leading, 5)
                        }
                        TextField("", text: $fullName)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .autocapitalization(.words)
                            .keyboardType(.default)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                    }
                    ZStack(alignment: .leading) {
                        if username.isEmpty {
                            Text("Username")
                                .foregroundColor(Color.white.opacity(1))
                                .padding(.leading, 5)
                        }
                        TextField("", text: $username)
                            .padding()
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .keyboardType(.default)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            )
                    }
                    ZStack(alignment: .leading) {
                        if email.isEmpty {
                            Text("Email")
                                .foregroundColor(Color.white.opacity(1))
                                .padding(.leading, 5)
                        }
                        TextField("", text: $email)
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
                                .foregroundColor(Color.white.opacity(1))
                                .padding(.leading, 5)
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
                    ZStack(alignment: .leading) {
                        if confirmPassword.isEmpty {
                            Text("Confirm Password")
                                .foregroundColor(Color.white.opacity(1))
                                .padding(.leading, 5)
                        }
                        SecureField("", text: $confirmPassword)
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
                
                // Sign Up Button
                Button(action: signUp) {
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
                .padding(.horizontal, 20)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                if isLoading {
                    ProgressView()
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $navigateToWelcomePage) {
            WelcomeView(isPersonalDetailsFilled: false, isGoalSetForUser: false, isFitnessGoalsSet: false)
        }
    }
    
    private func signUp() {
        guard !fullName.isEmpty, !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        isLoading = true
        
        let jsonData: [String: Any] = [
            "name": fullName,
            "email": email.lowercased(),
            "password": password.lowercased(),
            "username": username.lowercased(),
        ]
        
        // Serialize to JSON data
        guard let data = try? JSONSerialization.data(withJSONObject: jsonData, options: []) else {
            errorMessage = "Failed to serialize data."
            return
        }
        
        NetworkService.shared.postData(to: "http://localhost:4000/api/v1/sign-up", with: data) { (result: Result<SignUpResponse, NetworkError>) in
            isLoading = false
            errorMessage = nil
            switch result {
            case .success(let response):
                if response.success {
                    print("Response: \(response)")
                    print("Signup successful: \(response.message)")
                    navigateToWelcomePage = true
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

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
