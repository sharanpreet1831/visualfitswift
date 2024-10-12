//
//  DiscoverView.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 12/10/24.
//

import SwiftUI

struct DiscoverView: View {
    @State private var selectedTab: Int = 0
    @State private var showNewPostView: Bool = false // Control navigation to NewPostView

    var body: some View {
        NavigationView {
            VStack {
                // Header Section with "+" button
                HStack {
                    Text("Discover")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    
                    // "+" Button
                    Button(action: {
                        // Set this to true to open NewPostView
                        showNewPostView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.yellow) // Change button color if needed
                    }
                    .background(
                        // NavigationLink to navigate to NewPostView
                        NavigationLink(destination: NewPostView(), isActive: $showNewPostView) {
                            EmptyView()
                        }
                    )
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Segmented Control
                Picker(selection: $selectedTab, label: Text("Discover Options")) {
                    Text("Journeys").tag(0)
                    Text("Transformations").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .colorMultiply(.yellow)

                // Content Section
                ScrollView {
                    if selectedTab == 0 {
                        JourneyListView()
                    } else {
                        TransformationListView()
                    }
                }
            }
            .tabItem {
                Image(systemName: "globe")
                Text("Discover")
            }
            .background(Color.black.edgesIgnoringSafeArea(.all)) // Set the background to black
        }
    }
}

struct JourneyListView: View {
    var body: some View {
        VStack {
            ForEach(0..<5) { index in
                JourneyCardView(username: "Ashu", journeyDescription: "My 90 Days transformation", likes: 20, comments: 15)
            }
        }
    }
}

struct TransformationListView: View {
    var body: some View {
        VStack {
            ForEach(0..<5) { index in
                JourneyCardView(username: "Harsh", journeyDescription: "Hardwork pays well!", likes: 30, comments: 10)
            }
        }
    }
}

struct JourneyCardView: View {
    var username: String
    var journeyDescription: String
    var likes: Int
    var comments: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Profile icon placeholder
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 10)

                VStack(alignment: .leading) {
                    Text(username)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(journeyDescription)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Spacer()
                
                // Follow Button
                Button(action: {
                    // Follow action
                }) {
                    HStack {
                        Text("Follow")
                            .foregroundColor(.black) // Change text color if needed
                    }
                    .padding(10)
                    .background(Color.gray.opacity(0.9))
                    .cornerRadius(10)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding()

            // Before and After Images
            HStack {
                Spacer()
                Image("before") // Replace with actual images
                    .resizable()
                    .frame(width: 150, height: 250)
                
                Image("after") // Replace with actual images
                    .resizable()
                    .frame(width: 150, height: 250)
                Spacer()
            }
            .padding(.horizontal)

            // Like and Comment Buttons
            HStack {
                Button(action: {
                    // Like action
                }) {
                    HStack {
                        Image(systemName: "heart")
                        Text("\(likes)")
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.9))
                    .cornerRadius(20)
                }
                .buttonStyle(BorderlessButtonStyle())

                Button(action: {
                    // Comment action
                }) {
                    HStack {
                        Image(systemName: "message")
                        Text("\(comments)")
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.9))
                    .cornerRadius(20)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
