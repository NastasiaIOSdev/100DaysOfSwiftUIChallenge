//
//  AddView.swift
//  iExpense
//
//  Created by Анастасия Ларина on 24.02.2024.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    @State private var currency = "USD"
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    let currencies = ["USD", "EUR", "RUB"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.navigationLink)
                
                Picker("Currency", selection: $currency) {
                    ForEach(currencies, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.navigationLink)
                
                TextField("Amount", value: $amount, format: .currency(code: "\(currency)"))
                    .keyboardType(.decimalPad)
              
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    let item = ExpenceItem(
                        name: name,
                        type: type,
                        currency: currency,
                        amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
