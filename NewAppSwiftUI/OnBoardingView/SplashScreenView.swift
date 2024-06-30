import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var animationAmount = 1.0
    
    var body: some View {
        // MARK: Background
        ZStack {
            if isActive {
                ContentView()
            } else {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    // MARK: Title
                    Text("Tactile Quantum\nHeart Rate Stabilizer")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.black)
    
                    VStack {
                        Spacer()
                        // MARK: Heart Animation
                        Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 180, height: 180)
                                .foregroundColor(.red)
                                .overlay {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .frame(width: 180, height: 180)
                                        .foregroundColor(.red)
                                        .scaleEffect(animationAmount)
                                        .opacity(2 - animationAmount)
                                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: animationAmount)
                                }
                        
                            .onAppear {
                                animationAmount = 2
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        isActive = true
                                    }
                                }
                            }
                            .padding()
                        Spacer()
                    }
                    
                    VStack {
                        // MARK: Team Info
                        Text("Dr. Fractal Team 🇺🇦")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(.black)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
