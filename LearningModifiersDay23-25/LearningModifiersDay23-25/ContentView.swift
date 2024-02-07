//
//  ContentView.swift
//  LearningModifiersDay23-25
//
//  Created by Анастасия Ларина on 07.02.2024.
//

import SwiftUI

//MARK: - Custom containers
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    @ViewBuilder let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}

//MARK: - View composition
struct CapsuleText: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .padding()
            .background(.blue)
            .clipShape(Capsule(style: .continuous))
    }
}

//MARK: - View custom modifier
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundStyle(.red)
            .padding()
            .background(.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct WaterMark: ViewModifier {
    //stored property
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
                Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

extension View {
    func waterMarked(with text: String) -> some View {
        modifier(WaterMark(text: text))
    }
}

struct ContentView: View {
    @State private var usedRedText = false
    var moto1: some View {
        Text("SantaBarbara")
    }
    let moto2 = Text("SilentHills")

   @ViewBuilder var spells: some View {
            Text("Banana")
            Text("Kiwi")
    }
    
    var spells2: some View {
  //    VStack {
        Group {
            Text("Banana")
            Text("Kiwi")
        }
    }
    
    
    var body: some View {
//MARK: - Custom containers
        GridStack(rows: 4, columns: 4) { row, col in
          //  HStack{
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
       //     }
        }
        
//MARK: - View composition
        ScrollView {
            VStack(spacing: 10) {
                Text("First")
                    .font(.caption)
                    .padding()
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(Capsule(style: .continuous))
                Text("Second")
                    .font(.caption)
                    .padding()
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(Capsule(style: .continuous))
                CapsuleText(text: "Third")
                    .foregroundStyle(.yellow)
                CapsuleText(text: "Fourth")
                Text("Sixth")
                    .modifier(Title())
                Text("Seventh")
                    .titleStyle()
                
                VStack(spacing: 15){
                    VStack {
//MARK: - условный модификатор
                        if usedRedText {
                            Button("Button new") {
                                usedRedText.toggle()
                            }
                            .foregroundStyle(.yellow)
                        } else {
                            Button("Button new") {
                                usedRedText.toggle()
                            }
                            .foregroundStyle(.brown)
                        }
                    }
                }
                
                VStack {
//MARK: - модификаторы окружения
                    Text("Disseldooorf")
                        .font(.largeTitle)
                        .blur(radius: 0)
                    Text("Hamburger")
                    Text("Munihhhh")
                    Text("Almerrre")
                }
                .font(.title)
                .blur(radius: 2)
//MARK - viewa as prooerties
                VStack {
                    moto1
                        .foregroundStyle(.red)
                    moto2
                        .foregroundStyle(.blue)
                }
                
//MARK: - View custom modifier
                Color.blue
                    .frame(width: 300, height: 100)
                    .waterMarked(with: "Hacking with Swift")
                
//MARK: - Custom containers
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
