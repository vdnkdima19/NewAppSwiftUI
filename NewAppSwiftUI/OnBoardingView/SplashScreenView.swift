import SwiftUI

struct SplashScreenView: View {
    @Binding var isActive: Bool
    @Binding var animationAmount: Double
    let titleText: String = "Tactile Quantum\nHeart Rate Stabilizer"
    let teamInfoText: String = "Dr. Fractal Team 🇺🇦"
    let imageHeart = Image(systemName: "heart.fill")
    
    var body: some View {
        // MARK: Background
        ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    // MARK: Title
                    setText(someText: titleText) .multilineTextAlignment(.center)
    
                    VStack {
                        Spacer()
                        // MARK: Heart Animation
                        setImage(image:  imageHeart)
                                .overlay {
                                    setImage(image:  imageHeart)
                                        .scaleEffect(animationAmount)
                                        .opacity(2 - animationAmount)
                                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: animationAmount)
                                }
                        
                            .onAppear {
                                onAppearFunc()
                            }
                            .padding()
                        Spacer()
                    }
                    
                    VStack {
                        // MARK: Team Info
                        setText(someText: teamInfoText)
                    }
                    
                }
            }
        }
    private func onAppearFunc() {
        animationAmount = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isActive = true
            }
        }
    }
    @ViewBuilder
    private func setText(someText: String) -> some View {
        Text(someText)
        .foregroundColor(.black)
        .font(.title)
        .fontWeight(.bold)
        .padding()
    }
    @ViewBuilder
    private func setImage(image: Image) -> some View {
        image
        .font(.system(size: 180))
        .foregroundColor(.red)
    }
}

#Preview {
    RootView()
}
