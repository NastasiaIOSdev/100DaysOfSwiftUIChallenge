//
//  ContentView.swift
//  Moonshot
//
//  Created by Анастасия Ларина on 25.02.2024.
//

import SwiftUI

struct MissionItemView: View {
    let mission: Mission
    
    var body: some View {
        VStack {
            Image(mission.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            VStack {
                Text(mission.displayName)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(mission.formattedLaunchDate)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(Color.lightBackground)
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.lightBackground, lineWidth: 2)
        )
    }
}

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    @State private var showingGrid = true

    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                if showingGrid {
                    LazyVGrid(columns: columns) {
                        ForEach(missions) { mission in
                            NavigationLink {
                                MissionView(mission: mission, astrounaft: astronauts)
                            } label: {
                                VStack {
                                    MissionItemView(mission: mission)
                                }
                            }
                        }
                    }
                } else {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astrounaft: astronauts)
                        } label: {
                            HStack(alignment: .top) {
                                    MissionItemView(mission: mission)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingGrid.toggle()
                    }) {
                        Image(systemName: showingGrid ? "square.grid.2x2" : "list.bullet")
                            .foregroundStyle(.white)
                    }
                }
            }
            .preferredColorScheme(.dark)
            .background(Color.darkBackground)
        }
    }
}

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
