//
//  ContentView.swift
//  iExpense
//
//  Created by Анастасия Ларина on 23.02.2024.
//

import SwiftUI

struct ExpenceItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let currency: String
    let amount: Double
}

class Expenses: ObservableObject {
    @Published var items = [ExpenceItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItem = try? JSONDecoder().decode([ExpenceItem].self, from: savedItems) {
                items = decodedItem
                return
            }
        }
        items = []
    }
    
    @Published var showingAddExpense = false
}

struct ContentView: View {
    @ObservedObject private var expenses = Expenses()
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Business")) {
                    ForEach(expenses.items.filter { $0.type == "Business"}) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete(perform: { IndexSet in
                        removeItems(at: IndexSet, type: "Business")
                    })
                }
                
                Section(header: Text("Personal")) {
                    ForEach(expenses.items.filter { $0.type == "Personal"}) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete(perform: { IndexSet in
                        removeItems(at: IndexSet, type: "Personal")
                    })
                }
            }
            .navigationTitle("iExpnse")
            .toolbar {
                Button {
                    expenses.showingAddExpense = true
                    
                } label: {
                    Label("Add Expense", systemImage: "plus")
                }
            }
            .sheet(isPresented: $expenses.showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, type: String) {
        let itemsFilter = expenses.items.filter { $0.type == type }
        let removeIndex = Array(offsets)
        removeIndex.forEach { index in
            if let index = expenses.items.firstIndex(where: { $0.id == itemsFilter[index].id }) {
                expenses.items.remove(at: index)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ExpenseRow: View {
    let item: ExpenceItem
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            Spacer()

            if item.amount < 10 {
                Text(item.amount, format: .currency(code: "\(item.currency)"))
                    .foregroundStyle(.blue)
            } else if item.amount < 100 {
                Text(item.amount, format: .currency(code: "\(item.currency)"))
                    .foregroundStyle(.green)
            } else {
                Text(item.amount, format: .currency(code: "\(item.currency)"))
                    .foregroundStyle(.red)
            }
        }
    }
}
