import SwiftUI

struct CustomTimePicker: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    var timerRunning: Bool
    
    let minutesText = "хв"
    let secondsText = "c"

    var body: some View {
        HStack {
            if !timerRunning {
                Picker("minutes", selection: $minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)")
                            .foregroundColor(.gray)
                            .font(.title2)
                            .tag(minute)
                    }
                }
                setText(someText: minutesText)

                Picker("seconds", selection: $seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second)")
                            .foregroundColor(.gray)
                            .font(.title2)
                            .tag(second)
                    }
                }
                setText(someText: secondsText)
            }
        }
        .pickerStyle(.wheel)
        .opacity(timerRunning ? 0.0 : 1.0) 
        .disabled(timerRunning)
    }
    
    @ViewBuilder
    private func setText(someText: String) -> some View {
        Text(someText)
            .foregroundColor(.white)
            .font(.title)
    }
}
