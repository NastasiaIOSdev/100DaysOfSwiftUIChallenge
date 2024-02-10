//
//  SimplePickerView.swift
//  ColorMixer
//
//  Created by Анастасия Ларина on 09.02.2024.
//

import SwiftUI

private enum Constants {
    static let nameOfPage = "Color Mixer"
    static let imagePlusName = "plus"
    static let imageEqualName = "equal"
    static let typeColorRGBOnTitle = "RGB"
    
    static let picherSheetTitle = "Select Color"
    static let picherSheetRedTitle = "Red"
    static let picherSheetBlueTitle = "Blue"
    static let picherSheetGreenTitle = "Green"
    static let picherSheetYellowTitle = "Yellow"
    static let picherSheetBlackTitle = "Black"
    static let picherSheetOrangeTitle = "Orange"
    static let picherSheetWhiteTitle = "White"
}

private enum Language: String, CaseIterable {
    case ru = "RU"
    case en = "EN"
}

struct SimplePickerView: View {
    @State private var selectedColorOne: Color = .red
    @State private var selectedColorTwo: Color = .blue
    @State private var isColorPckerOneShowing = false
    @State private var isColorPckerTwoShowing = false
    @State private var selectedLanguage = Language.en
    
    private let language: [Language] = [.ru, .en]
    
    private var mixedColor: Color {
        return Color(
            red: (selectedColorOne.components.red + selectedColorTwo.components.red) / 2,
            green: (selectedColorOne.components.green + selectedColorTwo.components.green) / 2,
            blue: (selectedColorOne.components.blue + selectedColorTwo.components.blue) / 2
        )
    }
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [
                    Color(red: 0.71, green: 0.32, blue: 0.43),
                    Color(red: 0.92, green: 0.86, blue: 0.82)],
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack(spacing: 15) {
                
                Text(LocalizedStringKey("Color Mixer"))
                    .font(.system(.largeTitle))
                    .padding(.top, 10)
                
                Text(LocalizedStringKey(selectedColorOne.description.capitalized))
                    .titleStyle()
                
                SimpleColorPickerView(
                    color: $selectedColorOne,
                    isColorPckerShowing: $isColorPckerOneShowing)
                
                Image(systemName: Constants.imagePlusName)
                    .titleStyle()
                
                Text(LocalizedStringKey(selectedColorTwo.description.capitalized))
                    .titleStyle()
                
                SimpleColorPickerView(
                    color: $selectedColorTwo,
                    isColorPckerShowing: $isColorPckerTwoShowing)
                
                
                Image(systemName: Constants.imageEqualName)
                    .titleStyle()
                
                Text("\(Constants.typeColorRGBOnTitle) \(mixedColor.hexToRGBDescription)")
                    .titleStyle()
                
                Circle()
                    .frame(width: 70, height: 70)
                    .foregroundColor(mixedColor)
                
                Picker("", selection: $selectedLanguage) {
                    ForEach(language, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 100)
                .padding(.top, 30)
            }
            .environment(\.locale, .init(identifier: selectedLanguage.rawValue))
        }
    }
}

struct SimpleColorPickerView: View {
    @Binding var color: Color
    @Binding var isColorPckerShowing: Bool
    
    var body: some View {
        Circle()
            .frame(width: 70, height: 70)
            .foregroundColor(color)
            .onTapGesture {
                isColorPckerShowing = true
            }
            .colorPickerViewSheet(isPresented: $isColorPckerShowing, color: $color)
    }
}

struct ColorPickerViewSheet: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var color: Color
    
    func body(content: Content) -> some View {
        content
            .actionSheet(isPresented: $isPresented) {
                ActionSheet(
                    title: Text(NSLocalizedString(Constants.picherSheetTitle, comment: "")),
                    buttons: [
                        .default(Text(NSLocalizedString(Constants.picherSheetRedTitle, comment: ""))) { color = .red },
                        .default(Text(NSLocalizedString(Constants.picherSheetBlueTitle, comment: ""))) { color = .blue },
                        .default(Text(NSLocalizedString(Constants.picherSheetGreenTitle, comment: ""))) { color = .green },
                        .default(Text(NSLocalizedString(Constants.picherSheetYellowTitle, comment: ""))) { color = .yellow },
                        .default(Text(NSLocalizedString(Constants.picherSheetBlackTitle, comment: ""))) { color = .black },
                        .default(Text(NSLocalizedString(Constants.picherSheetWhiteTitle, comment: ""))) { color = .white },
                        .default(Text(NSLocalizedString(Constants.picherSheetOrangeTitle, comment: ""))) { color = .orange },
                        .cancel()
                    ]
                )
            }
    }
}

extension View {
    func colorPickerViewSheet(isPresented: Binding<Bool>, color: Binding<Color>) -> some View {
        self.modifier(ColorPickerViewSheet(isPresented: isPresented, color: color))
    }
}

extension Color {
    var components: (red: Double, green: Double, blue: Double, alpha: Double) {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (Double(red), Double(green), Double(blue), Double(alpha))
    }
}

extension Color {
    var hexToRGBDescription: String {
        let components = self.components
        let red = Int(components.red * 255)
        let green = Int(components.green * 255)
        let blue = Int(components.blue * 255)
        
        return "(\(red), \(green), \(blue))"
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.headline))
            .padding(5)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct SimplePickerView_Previews: PreviewProvider {
    static var previews: some View {
        SimplePickerView()
    }
}
