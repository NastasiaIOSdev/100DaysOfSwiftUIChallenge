//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Анастасия Ларина on 06.02.2024.
//

import SwiftUI

struct FlagImage: View {
    var name: String
    var body: some View {
        Image(name)
            .clipShape(RoundedRectangle(cornerRadius: 100))
            .shadow(radius: 5)
    }
}

struct LargeBlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundStyle(.blue)
    }
}

extension View {
    func largeBlueTitleStyle() -> some View {
        self.modifier(LargeBlueTitle())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Italy", "Poland", "UK"].shuffled()
    @State private var correctAnswear = Int.random(in: 0...2)
    @State private var showingscore = false
    @State private var scoreTitle = ""
    @State private var usersScore = 0
    @State private var numbersQuestion = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: .mint, location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .largeBlueTitleStyle()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswear])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .foregroundStyle(.secondary)
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagetapped(number)
                        } label: {
                            FlagImage(name: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(usersScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingscore) {
            Button("Continue", action: {
                if numbersQuestion < 8 {
                    askQuestion()
                } else {
                    restart()
                }
            })
        } message: {
            if numbersQuestion == 8 {
                Text("Your FINAL score: \(usersScore)! Restarting the Game!")
            } else {
                Text("Your score is \(usersScore)")
            }
        }
    }
    func flagetapped(_ number: Int) {
        numbersQuestion += 1
            if number == correctAnswear {
                scoreTitle = "Correct!"
                usersScore += 1
            } else {
                scoreTitle = "Wrong! That’s the flag of \(countries[number])"
            }
            showingscore = true
        }
    func askQuestion() {
        if numbersQuestion < 8 {
            countries.shuffle()
            correctAnswear = Int.random(in: 0...2)
        } else {
            showingscore = true
        }
    }
    
    func restart() {
        numbersQuestion = 0
        usersScore = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
