import SwiftUI

struct ProfileView: View {
    @State private var showLogoutModal: Bool = false // For logout confirmation modal
    @State private var navigateToWelcomeView: Bool = false // To control navigation after logout
    
    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            
            // Profile Image Section
            VStack {
                if let imageUrlString = UserDefaults.standard.string(forKey: "profilePicture") {
                    if let imageUrl = URL(string: imageUrlString.replacingOccurrences(of: "svg", with: "png")) {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                }

                Button(action: {
                    // Action to change profile image
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(Color.black).frame(width: 40, height: 40))
                        .offset(x: 40, y: -40)
                }
                
                Text(UserDefaults.standard.string(forKey: "name") ?? "Unknown")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()

                Text(UserDefaults.standard.string(forKey: "email") ?? "Unknown")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer().frame(height: 20)
            
            // Stats Section
            HStack(spacing: 40) {
                StatView(iconName: "figure.run", statValue: "123", statLabel: "Total Steps")
                StatView(iconName: "flame", statValue: "7200 cal", statLabel: "Burned")
                StatView(iconName: "figure.strengthtraining.traditional", statValue: "2", statLabel: "Done")
            }
            .padding()
            
            Spacer().frame(height: 30)
            
            // Settings Section
            VStack {
                Button(action: {
                    // Action for "Personal" section
                    print("Personal tapped")
                }) {
                    SettingOptionView(iconName: "person.fill", label: "Personal")
                }
                
                Button(action: {
                    // Action for "General" section
                    print("General tapped")
                }) {
                    SettingOptionView(iconName: "gearshape.fill", label: "General")
                }
                
                Button(action: {
                    // Action for "Notification" section
                    print("Notification tapped")
                }) {
                    SettingOptionView(iconName: "bell.fill", label: "Notification")
                }
                
                Button(action: {
                    // Action for "Help" section
                    print("Help tapped")
                }) {
                    SettingOptionView(iconName: "questionmark.circle.fill", label: "Help")
                }
            }
            .padding()
            
            Spacer()
            
            // Logout Button
            Button(action: {
                showLogoutModal.toggle()
            }) {
                Text("Logout")
                    .foregroundColor(.red)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }.padding(.bottom,40)
            
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Set the background to black
        .fullScreenCover(isPresented: $navigateToWelcomeView) {
            WelcomeView(
                isPersonalDetailsFilled: UserDefaults.standard.bool(forKey: "personalDetailsFlag") ?? false,
                isGoalSetForUser: UserDefaults.standard.bool(forKey: "isGoalSetForUser") ?? false,
                isFitnessGoalsSet: UserDefaults.standard.bool(forKey: "isFitnessGoalsSet") ?? false
            )
        }
        .alert(isPresented: $showLogoutModal) {
            Alert(
                title: Text("Logout"),
                message: Text("Are you sure you want to log out?"),
                primaryButton: .destructive(Text("Logout")) {
                    UserDefaults.standard.removeObject(forKey: "accessToken")
                    UserDefaults.standard.removeObject(forKey: "personalDetailsFlag")
                    UserDefaults.standard.removeObject(forKey: "isGoalSetForUser")
                    UserDefaults.standard.removeObject(forKey: "isFitnessGoalsSet")
                    navigateToWelcomeView = true
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct StatView: View {
    var iconName: String
    var statValue: String
    var statLabel: String
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
            Text(statValue)
                .foregroundColor(.white)
                .font(.headline)
            Text(statLabel)
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

struct SettingOptionView: View {
    var iconName: String
    var label: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.white)
            Text(label)
                .foregroundColor(.white)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(10)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
