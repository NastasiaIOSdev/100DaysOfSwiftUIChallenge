//
//  ContentView.swift
//  TemperatureConversionChallange
//
//  Created by Анастасия Ларина on 05.02.2024.
//

import SwiftUI

enum Temperature: String, CaseIterable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    case kelvin = "Kelvin"
}

struct ContentView: View {
    
    @State private var checkAmouttemperature = 0.0
    @State private var selectedTemperature = Temperature.celsius
    @State private var selectedTemperature2 = Temperature.kelvin
    @FocusState private var amountIsFocused: Bool
    
    let temperature: [Temperature] = [.celsius, .fahrenheit, .kelvin]
    
    func convertTeperature(_ value: Double, from source: Temperature, to target: Temperature ) -> Double {
        switch (source, target) {
            
        case (.celsius, .fahrenheit):
            return value * 1.8 + 32
        case (.celsius, .kelvin):
            return value + 273.15
        case (.fahrenheit, .celsius):
            return (value - 32) / 1.8
        case (.fahrenheit, .kelvin):
            return (value + 459.67) * 5 / 9
        case (.kelvin, .celsius):
            return value - 273.15
        case (.kelvin, .fahrenheit):
            return (value - 273.15) * 1.8 + 32
        default:
            return value
        }
    }
    
    var totalAmoutCentigrates: Double {
        return convertTeperature(checkAmouttemperature, from: selectedTemperature, to: selectedTemperature2)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Choose convert from:") {
                    Picker("", selection: $selectedTemperature) {
                        ForEach(temperature, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Choose convert to") {
                    Picker("", selection: $selectedTemperature2) {
                        ForEach(temperature, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Enter the number of degrees") {
                    TextField("Amount", value: $checkAmouttemperature, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                
                Section("Сonversion result") {
                    Text("\(String(format: "%0.2f",totalAmoutCentigrates))")
                }
            }
            .navigationTitle("Temperature conversion")
            .navigationBarTitleDisplayMode(.inline)
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
