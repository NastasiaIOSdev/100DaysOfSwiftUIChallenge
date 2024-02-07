//
//  ContentView.swift
//  WeSplit
//
//  Created by Анастасия Ларина on 05.02.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPersentage2 = 0
    @State private var tipPersentage = 20
    @FocusState private var amountIsFocused: Bool
    
    var tipPersantages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPersentage2)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    
    var totalAmount: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let totalAmountBeel = Double(totalPerPerson * peopleCount)
        return totalAmountBeel
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                                
                Section("How mach do you want to tip") {
                    Picker("Tip persentage", selection: $tipPersentage2) {
                        ForEach(0..<101, id: \.self) {
                            Text("\($0) percent")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("Amount per person") {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
                
                Section("Total amount") {
                    if tipPersentage2 == tipPersantages[4] {
                        Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .foregroundStyle(.red)
                    } else {
                        Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .foregroundStyle(.black)
                    }
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
