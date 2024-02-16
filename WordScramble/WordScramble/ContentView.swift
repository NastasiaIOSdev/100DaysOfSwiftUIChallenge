//
//  ContentView.swift
//  WordScramble
//
//  Created by Анастасия Ларина on 16.02.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var userWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessege = ""
    @State private var showinError = false
    @FocusState private var startGameFocused: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .focused($startGameFocused)
                }
                
                Section {
                    ForEach(userWords, id: \.self) { word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
                
                Section {
                    Text("Count rootwords \(calculateScore().wordsCount)")
                    Text("Count their letter \(calculateScore().letterrsCount)")
                }
                
            }
            .navigationTitle(rootWord)
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Start Game") {
                        startGame()
                    }
                }
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert("Error title", isPresented: $showinError) {
            } message: {
                Text(errorMessege)
            }
            
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count >= 3 else {
            wordError(title: "Shorter than three letters!", message: "Shorter than three letters!")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "Word must be different from the start word!", message: "Word must be different from the start word.!")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more priginal")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word is Possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognaize", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            userWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                userWords.removeAll()
                startGameFocused = true
                newWord = ""
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !userWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspeledRange = checker.rangeOfMisspelledWord(
            in: word,
            range: range,
            startingAt: 0,
            wrap: false,
            language: "en")
        return misspeledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessege = message
        showinError = true
    }
    
    struct Score {
        let wordsCount: Int
        let letterrsCount: Int
    }
    
    func calculateScore() -> Score {
        let wordsCount = userWords.count
        let lettersCount = userWords.reduce(0) {
            $0 + $1.count
        }
       
        return Score(wordsCount: wordsCount, letterrsCount: lettersCount)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
