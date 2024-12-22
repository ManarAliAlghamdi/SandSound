import SwiftUI

struct SplashScreen: View {
    @State private var showStartingPage = false
    var body: some View {
        NavigationStack {
            ZStack {
                if showStartingPage{
                    StartingPage()
                }else{
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 164, height: 200)
                        .padding()
                    // }
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation{
                                    showStartingPage = true
                                }
                            }
                        }
                    
                }
            }
        }
    }
}
#Preview {
    SplashScreen()
       // .preferredColorScheme(.dark)

}
