//
//  MissionView.swift
//  Moonshot
//
//  Created by Анастасия Ларина on 25.02.2024.
//

import SwiftUI

struct DividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding()
    }
}

struct HorizontalScrollView: View {
    let crew: [MissionView.CrewMember]

    var body: some View {
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
}

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
                    .padding(.top)
                
                Text(mission.formattedLaunchDate)
                    .font(.body.bold())
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.top)
                
                DividerView()
                
                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                    .font(.title.bold())
                    .padding(.bottom, 5)
                    
                    Text(mission.description)
                    
                    DividerView()
                    
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 10)
                }
                .padding(.horizontal)
                
                HorizontalScrollView(crew: crew)
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
