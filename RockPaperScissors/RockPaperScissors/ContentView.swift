//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Анастасия Ларина on 08.02.2024.


import SwiftUI
enum CaseOfChoice: String, CaseIterable {
    case rock = "Rock"
    case paper = "Paper"
    case scissors = "Scissors"
}

struct MainViewStile: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
    }
}

extension View {
    func mainViewStyle() -> some View {
        modifier(MainViewStile())
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(
                .system(
                    size: 25,
                    weight: .bold,
                    design: .rounded))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var possibleMoves: [CaseOfChoice] = [.rock, .paper, .scissors]
    @State private var opponentChoise = Int.random(in: 0...2)
    @State private var gameStatus = Bool.random()
    @State private var showingScore = false
    @State private var showingAlert = false
    @State private var round = 1
    @State private var score = 0
 
    var body: some View {
        
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.74, green: 0.85, blue: 0.87), Color(red: 0.29, green: 0.62, blue: 0.68)] , startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(spacing: 15) {
                Spacer()
                Text("Opponent choose:")
                    .font(.system(size: 30))
                Text("\(possibleMoves[opponentChoise].rawValue)")
                    .titleStyle()
                Spacer()
                
                VStack(spacing: 15) {
                    HStack(spacing: 5){
                      Text("For")
                      Text("\(gameStatus ? "Win": "Lost")")
                            .titleStyle()
                      Text("I choose:")
                    }
                    .font(.system(size: 25))
                   
                    
                    HStack(spacing: 30) {
                        ForEach(0..<3) { number in
                            Button {
                                checkingMyMove(myMove: possibleMoves[number].rawValue)
                            } label: {
                                Image(possibleMoves[number].rawValue)
                                    .resizable()
                                    .frame(width: 70, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                    }
                }
                .mainViewStyle()
                
                Spacer()
                
                Text("Score: \(score), Round: \(round)")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
        }
        .onAppear {
            nextRound()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Game over!"),
                message: Text("Total score: \(score)"),
                dismissButton: .default(Text("Start Game again!")) {
                    self.restart()
                }
            )
        }
    }
    
    func movesWin(index: Int) -> [Int] {
        let movesWin: [Int]
        if gameStatus {
            switch index {
            case 0:
                movesWin = [1]
            case 1:
                movesWin = [2]
            case 2:
                movesWin = [0]
            default:
                movesWin = []
            }
            
        } else {
            switch index {
            case 0:
                movesWin = [2]
            case 1:
                movesWin = [0]
            case 2:
                movesWin = [1]
            default:
                movesWin = []
            }
        }
        return movesWin
    }
    
    func checkingMyMove(myMove: String) {
        guard let indexOfMyMove = possibleMoves.firstIndex(of: CaseOfChoice(rawValue: myMove)!) else { return }
        let movesWin = movesWin(index: indexOfMyMove)
        
        if movesWin.contains(opponentChoise) {
            score -= 1
        } else if opponentChoise == indexOfMyMove {
            score += 0
        } else {
            score += 1
        }
        
        round += 1
        if round == 10 {
            alertShowing()
        } else {
            nextRound()
        }
    }
    
    func alertShowing() {
        showingAlert = true
    }
    
    func restart() {
        score = 0
        round = 1
        nextRound()
    }
    
    func nextRound() {
        opponentChoise = Int.random(in: 0...2)
        gameStatus.toggle()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
