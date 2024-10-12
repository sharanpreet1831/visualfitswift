//
//  NewPostView.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 12/10/24.
//


import SwiftUI
import UIKit

// Image Picker wrapper to use with SwiftUI
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct NewPostView: View {
    @Environment(\.presentationMode) var presentationMode // To manage the back action
    @State private var caption: String = ""
    @State private var tagPeople: Bool = false
    @State private var audienceSelection: String = "Everyone"
    @State private var addLocation: Bool = false
    @State private var boostPost: Bool = false
    
    // For image picker
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        VStack(spacing: 20) {
            // Header Section
            HStack {
                Button(action: {
                    // Use presentation mode to dismiss the view
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                }
                Spacer()
                Text("New Post")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)

            // Image Preview and Caption Section
            VStack {
                if let image = selectedImage {
                    Image(uiImage: image) // Show selected image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(10)
                        .padding(.horizontal)
                } else {
                    Button(action: {
                        // Show image picker when the camera icon is tapped
                        showImagePicker = true
                    }) {
                        VStack {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.white)
                            Text("Tap to add a photo")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 250)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                // Caption Input Field
                TextField("Write a caption or add a poll...", text: $caption)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .colorScheme(.dark) // Ensures dark keyboard and appearance
            }

            // Options List (Form)
            Form {
                Section {
                    NavigationLink(destination: Text("Tag People View").foregroundColor(.white)) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.white)
                            Text("Tag people")
                                .foregroundColor(.white)
                        }
                    }
                    .listRowBackground(Color.gray.opacity(0.2)) // Gray background for row

                    HStack {
                        Image(systemName: "eye")
                            .foregroundColor(.white)
                        Text("Audience")
                            .foregroundColor(.white)
                        Spacer()
                        Text(audienceSelection)
                            .foregroundColor(.blue)
                        Text("NEW")
                            .foregroundColor(.blue)
                    }
                    .listRowBackground(Color.gray.opacity(0.2)) // Gray background for row

                    NavigationLink(destination: Text("Add Location View").foregroundColor(.white)) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.white)
                            Text("Add location")
                                .foregroundColor(.white)
                        }
                    }
                    .listRowBackground(Color.gray.opacity(0.2)) // Gray background for row
                }

                Section {
                    // Boost Post Toggle
                    Toggle(isOn: $boostPost) {
                        HStack {
                            Image(systemName: "arrow.up.right")
                                .foregroundColor(.white)
                            Text("Boost post")
                                .foregroundColor(.white)
                        }
                    }
                    .listRowBackground(Color.gray.opacity(0.2)) // Gray background for row
                }
            }
            .scrollContentBackground(.hidden) // Ensures the background color persists
            .background(Color.gray.opacity(0.2)) // Set form background to gray

            Spacer()

            // Share Button
            Button(action: {
                // Share post action
            }) {
                Text("Share")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Set background to black
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, isPresented: $showImagePicker)
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // Ensure to use NavigationView in the previews
            NewPostView()
        }
    }
}
