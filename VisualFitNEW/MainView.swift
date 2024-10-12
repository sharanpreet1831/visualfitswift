//
//  MainView.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 11/10/24.
//

import SwiftUI

struct MainView: View {
    @State var selectedTab = 1 // Set default tab (Peers tab)

    init() {
        // Customize the appearance of the tab bar
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black // Set tab bar background color to black
        
        // Set the tab bar appearance globally
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // First Tab: Summary
            SummaryView()
                .tabItem {
                    Label("Summary", systemImage: "circle.circle")
                }
                .tag(0)

            // Second Tab: Peers
            PeerView()
                .tabItem {
                    Label("Peers", systemImage: "person.3.fill")
                }
                .tag(1)

            // Third Tab: Discover
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "globe")
                }
                .tag(2)

            // Fourth Tab: Profile
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(3)
        }
        .accentColor(.yellow) // Set the tab bar icon and text color to white
    }
}

// Sample views for other tabs (Summary, Discover, Profile)
//struct DiscoverView: View {
//    var body: some View {
//        Text("Discover View")
//            .font(.largeTitle)
//    }
//}

//struct ProfileView: View {
//    var body: some View {
//        Text("Profile View")
//            .font(.largeTitle)
//    }
//}

#Preview {
    MainView()
}
