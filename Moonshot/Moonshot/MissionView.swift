//
//  MissionView.swift
//  Moonshot
//
//  Created by Анастасия Ларина on 25.02.2024.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Rectangle()
                    .frame(height: 2)
                    .foregroundStyle(.lightBackground)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                    .font(.title.bold())
                    .padding(.bottom, 5)
                    
                    Text(mission.description)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.lightBackground)
                        .padding()
                    
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 10)
                }
                .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(crew, id: \.role) { crewMember in
                            NavigationLink {
                                AstronautView(astronaut: crewMember.astronaut)
                            } label: {
                                HStack {
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .frame(width: 104, height: 72)
                                        .clipShape(Capsule())
                                        .overlay(
                                           Capsule()
                                            .strokeBorder(.white, lineWidth: 1)
                                        )
                                    VStack(alignment: .leading) {
                                        Text(crewMember.astronaut.name)
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                        Text(crewMember.role)
                                            .foregroundStyle(.secondary)
                                    }
                                    Rectangle()
                                        .frame(width: 2)
                                        .foregroundStyle(.lightBackground)
                                        .padding()
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    init(mission: Mission, astrounaft: [String: Astronaut]) {
        self.mission = mission
        self.crew = mission.crew.map { member in
            if let astronaut = astrounaft[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

struct MissionView_Previews: PreviewProvider {
   
    static var previews: some View {
       let missions: [Mission] = Bundle.main.decode("missions.json")
        let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
        return MissionView(mission: missions[0], astrounaft: astronauts)
            .preferredColorScheme(.dark)
    }
}
