import SwiftUI

@main
struct VisualFitNEWApp: App {
    // Store accessToken as a simple property
    private var accessToken: String {
        UserDefaults.standard.string(forKey: "accessToken") ?? ""
    }
    private var isPersonalDetailsFilled: String {
        UserDefaults.standard.string(forKey: "personalDetailsFlag") ?? ""
    }
    
    private var isGoalSetForUser: String {
        UserDefaults.standard.string(forKey: "isGoalSetForUser") ?? ""
    }

    var body: some Scene {
        WindowGroup {
            // Pass accessToken to ContentView
            ContentView(accessToken: accessToken,isPersonalDetailsFilled: isPersonalDetailsFilled,isGoalSetForUser: isGoalSetForUser)
                .onAppear {
                    print("Access Token: \(accessToken)")
                    print("isPersonalDetailsFilled: \(isPersonalDetailsFilled)")
                }
        }
    }
}

struct ContentView: View {
    let accessToken: String
    let isPersonalDetailsFilled: String
    let isGoalSetForUser: String

    var body: some View {
        if accessToken.isEmpty {
            WelcomeView()
        } else if(isPersonalDetailsFilled == "") {
            PersonalDetailsView()
        }else if(isGoalSetForUser == ""){
            SetGoalView()
        }else{
            MainView()
        }
    }
}
