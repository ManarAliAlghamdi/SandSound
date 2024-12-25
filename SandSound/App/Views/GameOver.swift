
import SwiftUI
struct GameOver: View {
    var body: some View {
        ZStack {
           
            Image("GameOver")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer() // Push buttons to the bottom
                
                HStack {
                    // Home Button
                    Button(action: {
                        // Action for Home button
                        print("Navigating to Home Page")
                    }) {
                        HStack {
                            Image(systemName: "house.fill") // Home icon
                            Text(" الرئيسيه")
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8)) // Button background
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    
                    Spacer() // Add spacing between buttons
                    
                    // Restart Button
                    Button(action: {
                        // Action for Restart button
                        print("Restarting the Game")
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise") // Restart icon
                            Text("اعاده اللعب")
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8)) // Button background
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding([.leading, .trailing, .bottom], 30) // Adjust spacing around the buttons
            }
        }
    }
}

#Preview {
    GameOver()
}
