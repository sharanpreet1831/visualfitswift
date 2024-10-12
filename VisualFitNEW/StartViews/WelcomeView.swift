//
//  WelcomeView.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 12/10/24.
//

//
//  WelcomeView.swift
//  check product
//
//  Created by iOS on 12/10/24.
//

import SwiftUI
import AuthenticationServices

struct WelcomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var navigateToNextPage = false  // State to trigger navigation

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
                            .foregroundColor(.white.opacity(0.8))

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

                    // Apple Sign-In Button with Styling
                    SignInWithAppleButton(.signIn, onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                    }, onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            print("Apple Sign-In successful: \(authResults)")
                        case .failure(let error):
                            print("Apple Sign-In failed: \(error.localizedDescription)")
                        }
                    })
                    .signInWithAppleButtonStyle(
                        colorScheme == .dark ? .white : .black
                    )
                    .frame(height: 55)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .shadow(radius: 5)

                    // Next Button with Gradient and Shadow
                    NavigationLink(destination: PersonalDetailsView(), isActive: $navigateToNextPage) {
                        Button(action: {
                            navigateToNextPage = true
                        }) {
                            Text("Next")
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
                    }
                    .isDetailLink(false)

                    
                }
            }
        }
    }
}

// Example Next Page (Replace with your actual next page)
struct NextPageView: View {
    var body: some View {
        VStack {
            Text("This is the next page!")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
