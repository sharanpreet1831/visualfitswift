//
//  SetGoal.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 12/10/24.
//

//
//  SetGoalView.swift
//  check product
//
//  Created by iOS on 12/10/24.
//

import SwiftUI

struct SetGoalView: View {
    @State private var selectedGoal: Int = 3 // Default selected value

    var body: some View {
        VStack(spacing: 30) {
            // Back Button
            HStack {
                Button(action: goBack) {
                    Label("Back", systemImage: "chevron.left")
                        .foregroundColor(.yellow)
                }
                Spacer()
            }
            .padding(.horizontal)

            Spacer()

            // Goal Icon
            Image(systemName: "target")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)

            // Title and Subtitle
            Text("Set your Goal")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Tell us how often would you like to exercise in a week")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

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

            // Next Button
            Button(action: sendGoalAndNavigate) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    // Function to handle navigation to the previous page
    func goBack() {
        // Replace with actual back navigation logic
        print("Back button pressed")
    }

    // Function to send selected goal and navigate to the next page
    func sendGoalAndNavigate() {
        let goalData = ["goal": selectedGoal]

        // Send data to backend
        sendToBackend(data: goalData)

        // Navigate to the next page (replace with actual navigation logic)
        print("Navigating to next page with goal: \(selectedGoal)")
    }

    // Function to send data to backend (replace with your backend logic)
    func sendToBackend(data: [String: Any]) {
        guard let url = URL(string: "https://your-backend-url.com/api/goal") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            request.httpBody = jsonData
        } catch {
            print("Failed to encode JSON: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("Failed to send data: \(error.localizedDescription)")
                return
            }
            print("Goal data sent successfully: \(response.debugDescription)")
        }.resume()
    }
}

struct SetGoalView_Previews: PreviewProvider {
    static var previews: some View {
        SetGoalView()
    }
}
