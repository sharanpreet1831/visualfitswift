import SwiftUI
import UIKit

// Image Picker View
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
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

            Button("Done") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .foregroundColor(.yellow)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// Summary View
struct SummaryView: View {
    @State private var headerHeight: CGFloat = 100
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State private var showCalendar = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 20) {
                        headerView
                        contentView
                            .padding(.horizontal)
                            .padding(.top, 20)
                    }
                    .padding(.bottom, 40) // Add some padding at the bottom to avoid being too close to the tab bar
                }
                .background(Color.black)
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.top) // Only ignore safe area at the top
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                toolbarButtons
            }
        }
        .accentColor(.white)
        .sheet(isPresented: $showCamera) {
            ImagePickerView(sourceType: .camera, selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showCalendar) {
            DatePickerView(selectedDate: $selectedDate)
        }
    }
    
    // Header View
    private var headerView: some View {
        GeometryReader { geometry in
            VStack {
                Text("Summary")
                    .font(.system(size: max(30 - (geometry.frame(in: .global).minY / 5), 20)))
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 50)
                    .opacity(Double(1 - (geometry.frame(in: .global).minY / 100)))
            }
            .frame(height: headerHeight)
        }
        .frame(height: headerHeight)
        .background(Color.black)
    }
    
    // Content View
    private var contentView: some View {
        VStack(spacing: 20) {
            transformationSection
            activitySection
            achievementsSection
        }
    }
    
    // Transformation Section
    private var transformationSection: some View {
        VStack {
            HStack(spacing: 0) {
                Image("before") // Placeholder
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 2, height: 200)
                    .clipped()
                
                Image("after") // Placeholder
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 2, height: 200)
                    .clipped()
            }
            
            Text("Your Expected Transformation")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 10)
        }
    }
    
    // Activity Section
    private var activitySection: some View {
        VStack {
            Text("Activity")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            
            HStack(spacing: 15) {
                ActivityCard(title: "Steps", value: "9,289")
                    .frame(width: UIScreen.main.bounds.width / 2 - 15)
                ActivityCard(title: "Calories", value: "565 Kcal")
                    .frame(width: UIScreen.main.bounds.width / 2 - 15)
            }
            .padding(.bottom)
            
            HStack(spacing: 15) {
                ActivityCard(title: "Distance", value: "2.1 km")
                    .frame(width: UIScreen.main.bounds.width / 2 - 15)
                ActivityCard(title: "Weekly Goal", value: "5 Days")
                    .frame(width: UIScreen.main.bounds.width / 2 - 15)
            }
        }
        .padding(.bottom)
    }
    
    // Achievements Section
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Achievements")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            
            HStack(spacing: 10) {
                AchievementBadge(days: 7)
                AchievementBadge(days: 15)
            }
        }
    }
    
    private var toolbarButtons: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showCamera = true }) {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.yellow)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showCalendar = true }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.yellow)
                }
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
            .frame(maxWidth: .infinity)
        }
    }

}

struct SummaryView_Preview: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
