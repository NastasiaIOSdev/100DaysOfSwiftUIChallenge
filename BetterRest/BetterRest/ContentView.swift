//
//  ContentView.swift
//  BetterRest
//
//  Created by Анастасия Ларина on 14.02.2024.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defoltWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    
    @State private var alertTitle = ""
    @State private var alertMessege = ""
    @State private var showingAlert = false
    
    static var defoltWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? .now
    }
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Desired amount of sleep")) {
                        Picker("number of hours", selection: $sleepAmount) {
                            ForEach(4..<13, id: \.self) {
                                Text("^[\($0) hours](inflect: true)")
                                    .foregroundColor(.indigo)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                    
                    Section(header: Text("Daily coffee in take")) {
                        Picker("number of cups", selection: $coffeeAmount) {
                            ForEach(0...20, id: \.self) {
                                Text("^[\($0) cups](inflect: true)")
                                    .foregroundColor(.brown)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                    Section(header: Text("When do you want to wake up?")) {
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
                
                Divider()
                
                Text("Recommended sleep time: \(calculateBadTime())")
                    .font(.title)
                    .foregroundColor(.indigo)
                    .padding()
                    .cornerRadius(10)
                
                Spacer()
                Spacer()
                
            }
            .navigationTitle("BetterRest")
            .background(Color(.systemGray6))
        }
    }
    
    func calculateBadTime() -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minite = (components.minute ?? 00) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minite), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
        
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return "Ssory? there was a problem calculating your bedtime."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
