import SwiftUI

extension Color {
    func mix(with color: Color, by percentage: Double) -> Color {
        let clampedPercentage = min(max(percentage, 0), 1)
        
        let components1 = UIColor(self).cgColor.components!
        let components2 = UIColor(color).cgColor.components!
        
        let red = (1.0 - clampedPercentage) * components1[0] + clampedPercentage * components2[0]
        let green = (1.0 - clampedPercentage) * components1[1] + clampedPercentage * components2[1]
        let blue = (1.0 - clampedPercentage) * components1[2] + clampedPercentage * components2[2]
        let alpha = (1.0 - clampedPercentage) * components1[3] + clampedPercentage * components2[3]
        
        return Color(red: red, green: green, blue: blue, opacity: alpha)
    }
}

struct ContentView: View {
    @State private var selectedColor1 = Color.red
    @State private var selectedColor2 = Color.blue
    @State private var isPicker1Presented = false
    @State private var isPicker2Presented = false
    @State private var isRussian = false
    
    let colorOptions: [(name: String, nameRU: String, color: Color)] = [
        ("Red", "Красный", .red),
        ("Green", "Зелёный", .green),
        ("Blue", "Синий", .blue),
        ("Yellow", "Жёлтый", .yellow),
        ("Purple", "Фиолетовый", .purple)
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            Toggle(isOn: $isRussian) {
                Text(isRussian ? "Русский" : "English")
            }
            .padding()
            
            VStack {
                Text(colorName(for: selectedColor1))
                    .font(.headline)
                    .padding(.bottom, 5)
                
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(selectedColor1)
                    .frame(width: 150, height: 150)
                    .onTapGesture {
                        isPicker1Presented = true
                    }
                    .sheet(isPresented: $isPicker1Presented) {
                        VStack {
                            Text(isRussian ? "Выберите первый цвет" : "Pick a first color")
                            Picker(isRussian ? "Выберите цвет" : "Please choose a color", selection: $selectedColor1) {
                                ForEach(colorOptions, id: \.color) { option in
                                    Text(isRussian ? option.nameRU : option.name).tag(option.color)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .padding()
                        }
                    }
            }
            
            Text("+")

            VStack {
                Text(colorName(for: selectedColor2))
                    .font(.headline)
                    .padding(.bottom, 5)
                
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(selectedColor2)
                    .frame(width: 150, height: 150)
                    .onTapGesture {
                        isPicker2Presented = true
                    }
                    .sheet(isPresented: $isPicker2Presented) {
                        VStack {
                            Text(isRussian ? "Выберите второй цвет" : "Pick a second color")
                            Picker(isRussian ? "Выберите цвет" : "Please choose a color", selection: $selectedColor2) {
                                ForEach(colorOptions, id: \.color) { option in
                                    Text(isRussian ? option.nameRU : option.name).tag(option.color)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .padding()
                        }
                    }
            }
            
            Text("=")
            
            VStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(selectedColor1.mix(with: selectedColor2, by: 0.5))
                    .frame(width: 150, height: 150)
            }
        }
        .padding()
    }
    
    func colorName(for color: Color) -> String {
        if let colorOption = colorOptions.first(where: { $0.color == color }) {
            return isRussian ? colorOption.nameRU : colorOption.name
        }
        return isRussian ? "Неизвестный цвет" : "Unknown Color"
    }
}

#Preview {
    ContentView()
}
