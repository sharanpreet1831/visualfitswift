//
//  PeerView.swift
//  VisualFitNEW
//
//  Created by Sharanpreet Singh  on 11/10/24.
//


import SwiftUI

struct PeerView: View {
    @State var selectedItem = 0

    // Static Data for Table
    let peers = [
        Peer(name: "Harsh", steps: 9999, calories: 898, goalAchieved: true),
        Peer(name: "Kunal", steps: 9970, calories: 798, goalAchieved: false),
        Peer(name: "Mahak", steps: 8889, calories: 898, goalAchieved: true),
        Peer(name: "Lakshay", steps: 8689, calories: 698, goalAchieved: false),
        Peer(name: "Ashu", steps: 7889, calories: 998, goalAchieved: true),
        Peer(name: "Riti", steps: 6874, calories: 990, goalAchieved: false),
        Peer(name: "Ankit", steps: 7800, calories: 750, goalAchieved: true),
        Peer(name: "Neha", steps: 6200, calories: 500, goalAchieved: false),
        Peer(name: "Pooja", steps: 9500, calories: 850, goalAchieved: true),
        Peer(name: "Rahul", steps: 8200, calories: 720, goalAchieved: true),
        Peer(name: "Simran", steps: 9100, calories: 880, goalAchieved: false),
        Peer(name: "Vikram", steps: 7500, calories: 670, goalAchieved: true)
    ]
    
    var body: some View {
        VStack {
            // Page Heading - Positioned to the left side and 80 points from top
            Text("Peers")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white) // Set to white
                .padding(.top, 80)
                .padding(.leading,-180)
            
            // Segmented Control - Full width
            Picker(selection: $selectedItem, label: Text("Segmented Control")) {
                Text("Leaderboard").tag(0)
                Text("Arena").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .colorMultiply(.yellow)
            
            // Centered Date
            HStack {
                Spacer()
                Text("Thu, Oct 10")
                    .font(.headline)
                    .foregroundColor(.white) // Set to white
                Spacer()
            }
            .padding(.top, 10)
            
            // Three Memoji-like symbols in Vertical Line - Centered horizontally
            HStack(spacing: 20) {
                Spacer()
                Image(systemName: "person.circle.fill") // Memoji 1
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                Image(systemName: "person.circle.fill") // Memoji 2
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                Image(systemName: "person.circle.fill") // Memoji 3
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.purple)
                Spacer()
            }
            .padding(.top, 30)
            
            // Scrollable Table Section
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Peers")
                            .fontWeight(.bold)
                            .frame(width: 100, alignment: .leading)
                            .foregroundColor(.yellow)
                        Spacer()
                        Text("Steps")
                            .fontWeight(.bold)
                            .frame(width: 70, alignment: .leading)
                            .foregroundColor(.yellow)
                        Text("Calories")
                            .fontWeight(.bold)
                            .frame(width: 100, alignment: .center)
                            .foregroundColor(.yellow)
                        Text("Goal")
                            .fontWeight(.bold)
                            .frame(width: 50, alignment: .leading)
                            .foregroundColor(.yellow)
                    }
                    .padding(.horizontal)
                    
                    // Table Rows (Static Data)
                    ForEach(peers) { peer in
                        HStack {
                            Text(peer.name)
                                .frame(width: 100, alignment: .leading)
                                .foregroundColor(.white) // Set text to white
                                .padding(.leading, 10)
                            Text("\(peer.steps)")
                                .frame(width: 70, alignment: .leading)
                                .foregroundColor(.white) // Set text to white
                            Text("\(peer.calories)")
                                .frame(width: 100, alignment: .center)
                                .foregroundColor(.white) // Set text to white
                            Image(systemName: peer.goalAchieved ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .frame(width: 50, alignment: .leading)
                                .foregroundColor(peer.goalAchieved ? .green : .red)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom,80)
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color.black) // Set background to black
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    PeerView()
}

// Static data model
struct Peer: Identifiable {
    let id = UUID()
    let name: String
    let steps: Int
    let calories: Int
    let goalAchieved: Bool
}
