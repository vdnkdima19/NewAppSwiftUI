import SwiftUI

struct TimerView: View {
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    @State private var inputText: String = ""
    @State private var showError = false
    @State private var showAlert: Bool = false
    @State private var textColor: Color = .white
    
    let titleTextAlert: String = "Увага"
    let textMessageAlert: String = "Таймер закінчився!"
    let textMessageErrorAlert: String = "Введіть коректне значення!"
    
    let imagePause = Image(systemName: "pause.circle")
    let imagePlay = Image(systemName: "play.circle")
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.5)
                        .foregroundColor(textColor)
                        .padding(20)
                    
                    Text(formattedTime())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(textColor)
                }
                
                Spacer()
                
                HStack {
                    TextField("Введіть значення", text: $inputText)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .keyboardType(.numberPad)
                        .onChange(of: inputText) { newValue in
                            inputText = newValue.filter { $0.isNumber }
                        }
                    
                    Button(action: {
                       if timer == nil {
                           if inputText.isEmpty {
                               showError = true
                           } else if let time = TimeInterval(inputText) {
                               timeRemaining = time
                               startTimer()
                           } else {
                               showError = true
                           }
                       } else {
                           stopTimer()
                       }
                   }) {
                       Text(timer == nil ? "Запустити" : "Зупинити")
                   }
                   .padding()
                   .buttonStyle(.borderedProminent)
                   .tint((timer == nil || showError || showAlert) ? Color.green : Color.red)
               }
                
                HStack {
                    if timer == nil || timeRemaining <= 0 {
                        setImage(image: imagePlay)
                            .onTapGesture {
                                startTimer()
                            }
                    } else {
                        setImage(image: imagePause)
                            .onTapGesture {
                                pauseTimer()
                            }
                    }
                }
                .padding()
                Spacer()
            }
            customOverlay()
        }
    }
    
    private func formattedTime() -> String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining <= 5 {
                    textColor = .red
                }
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
        inputText = ""
        timeRemaining = 0
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
            if showError {
                Color.black.opacity(0.7)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    setTitleText(someText: titleTextAlert)
                    setMessageText(someText: textMessageErrorAlert)
            
                    Button("OK") {
                        showError = false
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
            .font(.system(size: 60))
            .foregroundColor(.white)
    }
}

#Preview {
    TimerView()
}
