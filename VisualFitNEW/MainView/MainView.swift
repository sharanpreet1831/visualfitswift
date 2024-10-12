import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0 // Set default tab to Summary (0)

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
        .accentColor(.yellow) // Set the tab bar icon and text color to yellow
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
