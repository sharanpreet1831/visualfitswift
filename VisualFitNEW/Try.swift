//
//  Try.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 12/10/24.
//


import SwiftUI

struct SummaryView1: View {
    
    init() {
        // Customize the appearance of the navigation bar title
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.yellow] // Set title color to yellow
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("This is the Summary page")
                    .foregroundColor(.yellow) // Text color is yellow
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Fills the screen
            .background(Color.black) // Background is black
            .navigationTitle("Summary") // Title of the page
        }
        .accentColor(.yellow) // Changes the back button and other nav bar items to yellow
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView1()
    }
}

