//
//  FitnessGoalView.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 12/10/24.
//

//
//  FitnessGoleView.swift
//  check product
//
//  Created by iOS on 12/10/24.
//

import SwiftUI

struct FitnessGoalView: View {
    // State variables for tracking the goal and value
    @State private var selectedGoal: FitnessGoal = .weightLoss
    @State private var selectedValue: Int = 50 // Default value
    @State private var firstPartSubmitted = false
    
    // Enum for fitness goals
    enum FitnessGoal {
        case weightLoss, muscleGain
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
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
                
                Spacer()
                
                // Submit button (moved closer to the bottom for easier access)
                Button(action: {
                    submitGoal()
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: geometry.size.width * 0.85, height: 55) // Increase button height for larger touch area
                        .background(Color.yellow)
                        .cornerRadius(12)
                        .padding(.bottom, 20) // Move the button close to the bottom
                        .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.horizontal, 20)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        }
    }
    
    // Submit button action to send the selected goal and value to backend
    func submitGoal() {
        let goalString = selectedGoal == .weightLoss ? "Weight Loss" : "Muscle Gain"
        print("Selected Goal: \(goalString), Value: \(selectedValue)")
        
        // Simulate API call to backend
        sendToBackend(goal: goalString, value: selectedValue)
        
        // If weight loss was selected, show the muscle gain toggle after submission
        if selectedGoal == .weightLoss {
            firstPartSubmitted = true
            selectedGoal = .muscleGain // Automatically switch to muscle gain
        }
    }
    
    // Simulated API call
    func sendToBackend(goal: String, value: Int) {
        // Here you would integrate your actual backend request
        print("Sending data to backend: Goal: \(goal), Value: \(value)")
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
