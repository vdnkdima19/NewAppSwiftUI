import SwiftUI

struct SplashScreen: View {
    @Binding var isActive: Bool
    let titleText: String = "Таймер\nзворотного відліку"
    let teamInfoText: String = "Дмитрій Вдовенко"
    let progressTitleText: String = "Завантаження"
    var body: some View {
        // MARK: Background
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                // MARK: Title
                setText(someText: titleText)
                .multilineTextAlignment(.center)
                VStack {
                    Spacer()
                    // MARK: Load Animation
                    setProgressView(progreeTitle: progressTitleText)
                    
                        .onAppear {
                            onAppearFunc()
                        }
                        .padding()
                    Spacer()
                }
                
                VStack {
                    // MARK: Author Info
                    setText(someText: teamInfoText)
                }
            }
        }
    }
    private func onAppearFunc() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in 
            withAnimation {
                isActive = true
            }
        }
    }
    @ViewBuilder
    private func setText(someText: String) -> some View {
        Text(someText)
            .foregroundColor(.white)
            .font(.title)
            .fontWeight(.bold)
            .padding()
    }
    @ViewBuilder
    private func setProgressView(progreeTitle: String) -> some View {
        ProgressView(progreeTitle)
            .tint(.white)
            .foregroundColor(.white)
            .scaleEffect(1.3)
    }
}
#Preview {
    RootView()
}
