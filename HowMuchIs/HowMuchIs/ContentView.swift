//
//  ContentView.swift
//  HowMuchIs
//
//  Created by Анастасия Ларина on 23.02.2024.
//

import SwiftUI

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundStyle(.black)
            .font(.system(size: 24, weight: .bold, design: .rounded))
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(TitleStyle())
    }
}

struct ButtonCustomStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(15)
            .background(Color(red: 1, green: 1, blue: 1, opacity: 0.5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .foregroundStyle(.black)
            .font(.system(size: 16, weight: .bold, design: .rounded))
    }
}

extension View {
    func buttonCustomStyle() -> some View {
        self.modifier(ButtonCustomStyle())
    }
}

enum NumberOfQuestions: Int, CaseIterable {
    case five = 5
    case ten = 10
    case fifteen = 15
}

struct Question {
    var text: String
    var answer: Int
}

struct ContentView: View {
    @State private var startNuber = 2
    @State private var endNumber = 12
    @State private var numberOfQuestions = NumberOfQuestions.five
    @State private var answer = ""
    @State private var score = 0
    @State private var isGameActice = false
    @State private var settingsViewIsOn = false
    @State private var questions = [Question]()
    @State private var currentQuestionIndex = 0
    @State private var animationAmount = 0.0
    @FocusState private var answearIsFocused: Bool

    let numberOfQuestionOptions: [NumberOfQuestions] = [.five, .ten, .fifteen]
    
    private var answearStatus: String? {
        if let userAnswer = Int(answer) {
            let correctAnswer = questions[currentQuestionIndex].answer
            return userAnswer == correctAnswer ? "Correct !" : "Incorrect !"
        } else {
            return nil
        }
    }
    
    var body: some View {
        
        NavigationStack{
            ZStack {
                LinearGradient(colors: [Color(red: 0.95, green: 0.58, blue: 0.24), Color(red: 1.00, green: 0.97, blue: 0.36)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    
                    if isGameActice && settingsViewIsOn {
                        VStack(spacing: 15) {
                            Text("Question \(currentQuestionIndex + 1) of \(numberOfQuestions.rawValue)")
                                .titleStyle()
                            
                            Text(questions[currentQuestionIndex].text)
                                .font(.title)
                                .padding()
                            
                            VStack(alignment: .leading) {
                                Text("Your answer is:")
                                TextField("Number", text: $answer)
                                    .keyboardType(.numberPad)
                                    .focused($answearIsFocused)
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        HStack(spacing: 15) {
                            Button("Next question") {
                                nextQuestion()
                            }
                            .buttonCustomStyle()
                            .disabled(currentQuestionIndex == numberOfQuestions.rawValue - 1)
                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                            
                            Button("Restart game") {
                                restartGame()
                            }
                            .buttonCustomStyle()
                            .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
//                            .rotationEffect(.degrees(animationAmount), anchor: .center)
                        }
                        .padding()
                        
                        Text("Score: \(score)")
                            .padding()
                        
                        if let result = answearStatus {
                            Text(result)
                                .padding()
                        }
                        
                    } else {
                        Text("Settings:")
                            .titleStyle()
                        
                        Form {
                            Section("Choose Numbers:"){
                                Stepper(value: $startNuber, in: 2...12) {
                                    Text("Start from \(startNuber)")
                                }
                                
                                
                                Stepper(value: $endNumber, in: startNuber...12) {
                                    Text("End at \(endNumber)")
                                }
                            }
                            
                            Section("How many question?") {
                                Picker("", selection: $numberOfQuestions) {
                                    ForEach(numberOfQuestionOptions, id: \.self) {
                                        Text("\($0.rawValue)")
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        
                        Button("Start Game") {
                            withAnimation {
                                startGame()
                                animationAmount += 360
                            }
                        }
                        .buttonCustomStyle()
                    }
                }
                
            }
            .navigationTitle("Multiplication tasks")
        }
    }
    
    private func generateQuestion() {
        questions = []
        for _ in 0..<numberOfQuestions.rawValue {
            let randomNumberOne = Int.random(in: startNuber...endNumber)
            let randomNumberTwo = Int.random(in: startNuber...endNumber)
            let questionTitle = "\(randomNumberOne) * \(randomNumberTwo)"
            let answer = randomNumberOne * randomNumberTwo
            questions.append(Question(text: questionTitle, answer: answer))
        }
    }
    
    private func startGame() {
        isGameActice = true
        settingsViewIsOn = true
        generateQuestion()
        score = 0
        currentQuestionIndex = 0
    }
    
    private func restartGame() {
        isGameActice = false
        generateQuestion()
        score = 0
        currentQuestionIndex = 0
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < numberOfQuestions.rawValue - 1 {
            checkAnswear()
            currentQuestionIndex += 1
            answer = ""
        } else {
            restartGame()
        }
    }
    
    private func checkAnswear() {
        if let result = answearStatus {
            print(result)
        }
            if let userAnswer = Int(answer) {
                let correctAnswer = questions[currentQuestionIndex].answer
                if userAnswer == correctAnswer {
                    score += 1
                }
            }
    }
    private func buttonAnimation() {
        withAnimation {
            animationAmount += 360
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
