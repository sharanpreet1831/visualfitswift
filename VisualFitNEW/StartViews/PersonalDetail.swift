//
//  PersonalDetail.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 12/10/24.
//

//
//  PersonalDetailsView.swift
//  check product
//
//  Created by iOS on 12/10/24.
//

//
//  PersonalDetailsView.swift
//  check product
//
//  Created by iOS on 12/10/24.
//

import SwiftUI

struct PersonalDetailsView: View {
    @State private var gender: String = "Male"
    @State private var height: String = "170"  // Default height in cm as String
    @State private var weight: String = "50"   // Default weight in kg as String
    @State private var showSetGoalView: Bool = false // Control navigation to SetGoalView

    var body: some View {
        NavigationView {
            VStack(spacing: 70) {
                Spacer()

                // Profile Icon
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
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
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
                NavigationLink(destination: SetGoalView(), isActive: $showSetGoalView) {
                    Button(action: sendDataAndNavigate) {
                        Text("Next")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .shadow(color: Color.yellow.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                }
                
                
                .padding(.horizontal, 20)

                
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }

    // Function to send data and navigate
    func sendDataAndNavigate() {
        guard let heightValue = Int(height), let weightValue = Int(weight) else {
            print("Invalid height or weight input")
            return
        }

        let personalData = [
            "gender": gender,
            "height": heightValue,
            "weight": weightValue
        ] as [String: Any]

        sendToBackend(data: personalData)
        showSetGoalView = true // Trigger navigation
        print("Navigating to next page with data: \(personalData)")
    }

    // Backend data sending function
    func sendToBackend(data: [String: Any]) {
        guard let url = URL(string: "https://your-backend-url.com/api/personal-details") else { return }

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
            print("Data sent successfully: \(response.debugDescription)")
        }.resume()
    }
}


struct PersonalDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDetailsView()
    }
}
