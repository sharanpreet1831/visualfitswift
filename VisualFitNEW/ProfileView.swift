//
//  ProfileView.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 12/10/24.
//

import SwiftUI

struct ProfileView: View {
    // Replace this with your actual image
    @State private var profileImage = UIImage(named: "profile") ?? UIImage(systemName: "person.crop.circle.fill")!

    var body: some View {
        VStack {
            Spacer().frame(height: 50)
            
            // Profile Image Section
            VStack {
                Image(uiImage: profileImage) // Displaying profile image
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                
                // Edit button over the image
                Button(action: {
                    // Action to change profile image
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(Color.black).frame(width: 40, height: 40))
                        .offset(x: 40, y: -40)
                }
                
                Text("Sharan")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                
                Text("sharan@gmail.com")
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
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Set the background to black
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
