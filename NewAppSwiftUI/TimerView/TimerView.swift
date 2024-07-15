import SwiftUI

struct TimerView: View {
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    @State private var showAlert: Bool = false
    @State private var textColor: Color = .white
    
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    
    let titleTextAlert: String = "Увага"
    let textMessageAlert: String = "Таймер закінчився!"
    
    let imagePause = Image(systemName: "pause.circle")
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // MARK: Timer Display
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .opacity(0.5)
                        .foregroundColor(textColor)
                        .padding(10)
                    Text(formattedTime())
                        .font(.system(size: 46))
                        .fontWeight(.bold)
                        .foregroundColor(textColor)
                }
                
                Spacer()
                
                // MARK: Time Picker
                if timer == nil || timeRemaining <= 0 {
                    HStack {
                        CustomTimePickerView(minutes: $minutes, seconds: $seconds, timerRunning: timer != nil)
                        
                        Spacer()
                    }
                }
                
                // MARK: Control Buttons
                HStack {
                    setImage(image: imagePause)
                        .onTapGesture {
                            pauseTimer()
                        }
                        .opacity(timer != nil ? 1.0 : 0.0)
                    
                    Spacer()
                    
                    Button(action: {
                        if minutes > 0 || seconds > 0 {
                            if timer == nil || timeRemaining <= 0 {
                                startTimer()
                            } else {
                                stopTimer()
                            }
                        }
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 110, height: 110)
                            Text(timer == nil || timeRemaining <= 0 ? "Запустити" : "Зупинити")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                        .foregroundColor((timer == nil || timeRemaining <= 0) ? .green : .red)
                        .disabled(!(minutes > 0 || seconds > 0))
                    })
                }
                .padding()


            }
            customOverlay()
        }
    }
    
    // MARK: Methods
    private func formattedTime() -> String {
        let totalSeconds = (minutes * 60) + seconds
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        let totalSeconds = (minutes * 60) + seconds
        timeRemaining = TimeInterval(totalSeconds)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 5 {
                    textColor = .red
                }
                self.seconds = Int(timeRemaining) % 60
                self.minutes = Int(timeRemaining) / 60
            } else {
                stopTimer()
                showAlert = true
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        textColor = .white
        minutes = 0
        seconds = 0
    }
    
    private func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func customOverlay() -> some View {
        ZStack {
            if showAlert {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    setTitleText(someText: titleTextAlert)
                    setMessageText(someText: textMessageAlert)
                   
                    Button("OK") {
                        showAlert = false
                    }
                    
                    .padding()
                    .font(.title2)
                    .foregroundColor(.blue)
                    
                }
                .background(Color.white)
                .cornerRadius(5)
                .padding()
            }
        }
    }
    
    @ViewBuilder
    private func setTitleText(someText: String) -> some View {
        Text(someText)
        .font(.title2)
        .bold()
        .padding()
    }
    
    @ViewBuilder
    private func setMessageText(someText: String) -> some View {
        Text(someText)
        .font(.body)
        .padding()
    }
    
    @ViewBuilder
    private func setImage(image: Image) -> some View {
        image
            .font(.system(size: 110))
            .foregroundColor(.white)
    }
}

#Preview {
    TimerView()
}

struct CustomTimePickerView: View {
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
