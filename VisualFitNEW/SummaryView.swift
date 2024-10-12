//
//  SummaryView.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 11/10/24.
//
import SwiftUI
import UIKit

// View for handling image picker (Camera access)
struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType = .camera
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Date Picker View
struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle()) // Use graphical style for a calendar-like view
                .padding()
            
            Button("Done") {
                presentationMode.wrappedValue.dismiss() // Close the sheet when done is tapped
            }
            .padding()
            .foregroundColor(.yellow)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Optional: change the background to match the theme
    }
}

struct SummaryView: View {
    @State private var headerHeight: CGFloat = 100 // Initial height of the header
    @State private var showCamera = false // State to toggle camera view
    @State private var selectedImage: UIImage?
    @State private var showCalendar = false // State to toggle calendar view
    @State private var selectedDate = Date() // Holds the selected date

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 20) {
                        GeometryReader { geometry in
                            // Dynamic Shrinking Header if needed, currently placeholder
                            VStack {
                                // Dynamic Shrinking Summary Heading
                                Text("Summary")
                                    .font(.system(size: max(30 - (geometry.frame(in: .global).minY / 5), 20)))
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 50) // Padding from the top of the view
                                    .opacity(Double(1 - (geometry.frame(in: .global).minY / 100))) // Fade out slightly
                            }
                            .frame(height: 100)
                        }
                        .frame(height: headerHeight) // Initial height of the header
                        
                        // Main content of the page (scrollable)
                        VStack(spacing: 20) {
                            // Transformation Section
                            HStack(spacing: 0) { // No spacing for half-half layout
                                Image("before") // Placeholder, replace with actual image
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width / 2, height: 200)
                                    .clipped() // Ensures image fills the area

                                Image("after") // Placeholder, replace with actual image
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width / 2, height: 200)
                                    .clipped() // Ensures image fills the area
                            }

                            // Transformation Label
                            Text("Your Expected Transformation")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            // Activity Section
                            VStack {
                                Text("Activity")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                HStack {
                                    ActivityCard(title: "Steps", value: "9,289")
                                        .frame(width:200, height: 200)
                                        //.frame(width: UIScreen.main.bounds.width / 2 )
                                    // Ensure half the screen width
                                    ActivityCard(title: "Calories", value: "565 Kcal")
                                        .frame(width: UIScreen.main.bounds.width / 2 ) // Ensure half the screen width
                                }
                                
                                HStack {
                                    ActivityCard(title: "Distance", value: "2.1 km")
                                        .frame(width: UIScreen.main.bounds.width / 2 - 15) // Ensure half the screen width
                                    ActivityCard(title: "Weekly Goal", value: "5 Days")
                                        .frame(width: UIScreen.main.bounds.width / 2 - 15) // Ensure half the screen width
                                }
                            }
                            
                            // Achievements Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Achievements")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                
                                HStack(spacing: 10) {
                                    AchievementBadge(days: 7)
                                        .frame(maxWidth: .infinity) // Ensures equal spacing for badges
                                    AchievementBadge(days: 15)
                                        .frame(maxWidth: .infinity) // Ensures equal spacing for badges
                                }
                            }
                        }
                        .padding(.horizontal) // Horizontal padding for scroll content
                        .padding(.top, 20) // Top padding to give space under the header
                    }
                }
                .background(Color.black) // Background remains black
            }
            .background(Color.black) // Black background for the entire view
            .edgesIgnoringSafeArea(.all) // Extend background to edges
            .navigationBarTitleDisplayMode(.inline) // Enable collapsing of the title
            .toolbar {
                // Camera button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCamera = true
                    }) {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.yellow)
                    }
                }
                
                // Calendar button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCalendar = true
                    }) {
                        Image(systemName: "calendar")
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
        .accentColor(.white) // Make title and icons white in the navigation bar
        .sheet(isPresented: $showCamera) {
            ImagePickerView(sourceType: .camera, selectedImage: $selectedImage) // Show camera
        }
        .sheet(isPresented: $showCalendar) {
            DatePickerView(selectedDate: $selectedDate) // Show calendar
        }
    }
}

// ActivityCard and AchievementBadge structures

struct ActivityCard: View {
    var title: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.title2)
                .foregroundColor(.yellow)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
       
    }
}

struct AchievementBadge: View {
    var days: Int
    
    var body: some View {
        VStack {
            Image(systemName: "shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.black)
            Text("\(days) DAYS")
                .font(.title)
                .bold()
                .foregroundColor(.yellow)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(12)
        .frame(maxWidth: .infinity) // Ensures equal spacing for the badge
    }
}

#Preview {
    SummaryView()
}
