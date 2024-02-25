//
//  Astronaut.swift
//  Moonshot
//
//  Created by Анастасия Ларина on 25.02.2024.
//

import Foundation

//Identifiable - can use in side loops(ForEach)
//Codable - make instance from the strings

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}
