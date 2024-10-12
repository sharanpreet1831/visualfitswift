import SwiftUI

@main
struct VisualFitNEWApp: App {
    // Store accessToken as a simple property
    private var accessToken: String {
        UserDefaults.standard.string(forKey: "accessToken") ?? ""
    }
    private var isPersonalDetailsFilled: Bool {
        UserDefaults.standard.bool(forKey: "personalDetailsFlag") ?? false
    }
    
    private var isGoalSetForUser: Bool {
        UserDefaults.standard.bool(forKey: "isGoalSetForUser") ?? false
    }
    
    private var isFitnessGoalsSet: Bool {
        UserDefaults.standard.bool(forKey: "isFitnessGoalsSet") ?? false
    }

    var body: some Scene {
        WindowGroup {
            // Pass accessToken to ContentView
            ContentView(accessToken: accessToken,isPersonalDetailsFilled: isPersonalDetailsFilled,isGoalSetForUser: isGoalSetForUser,isFitnessGoalsSet: isFitnessGoalsSet)
                .onAppear {
                    print("Access Token: \(accessToken)")
                    print("isPersonalDetailsFilled: \(isPersonalDetailsFilled)")
                    print("isGoalSetForUser: \(isGoalSetForUser)")
                    print("isFitnessGoalsSet: \(isFitnessGoalsSet)")
                }
        }
    }
}

struct ContentView: View {
    let accessToken: String
    let isPersonalDetailsFilled: Bool
    let isGoalSetForUser: Bool
    let isFitnessGoalsSet: Bool

    var body: some View {
        if accessToken.isEmpty {
            WelcomeView(isPersonalDetailsFilled: isPersonalDetailsFilled,
                        isGoalSetForUser: isGoalSetForUser,
                        isFitnessGoalsSet: isFitnessGoalsSet)
        } else if(isPersonalDetailsFilled != true) {
            PersonalDetailsView()
        }else if(isGoalSetForUser != true){
            SetGoalView()
        }else if(isFitnessGoalsSet != true){
            FitnessGoalView()
        }else{
            MainView()
        }
    }
}
