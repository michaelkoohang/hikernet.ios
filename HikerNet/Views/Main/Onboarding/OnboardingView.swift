
import SwiftUI

// MARK: Main onboarding view for switching between pages
struct OnboardingView: View {
    @Binding var onboardingDone: Bool
    @State var numOfPages = 5
    @State var currentIndex = 0
    @State private var buttonTitle = "NEXT"
    @State private var buttonEnabled = true
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex.animation()) {
              ForEach(0..<numOfPages, id: \.self) { index in
                switch(index) {
                    case 1:
                        OnboardingPrivacyView(agreed: $buttonEnabled)
                    case 2:
                        OnboardingCarrierView(carrierRetrieved: $buttonEnabled)
                    case 3:
                        OnboardingIdView(idRetrieved: $buttonEnabled)
                    case 4:
                        OnboardingEndView()
                    default:
                        OnboardingStartView()
                }
              }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onAppear() {
                UIScrollView.appearance().isScrollEnabled = false
            }
            .onDisappear() {
                UIScrollView.appearance().isScrollEnabled = true
            }
            
            HStack {
                OnboardingIndexView(numberOfPages: numOfPages, currentIndex: currentIndex)
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
                Spacer()
                Button(action: {
                    withAnimation {
                        switch(currentIndex) {
                        case 0:
                            currentIndex += 1
                            buttonEnabled = false
                        case 1:
                            currentIndex += 1
                            buttonEnabled = false
                        case 2:
                            currentIndex += 1
                            buttonEnabled = false
                        case 3:
                            currentIndex += 1
                            buttonTitle = "DONE"
                        case 4:
                            onboardingDone = true
                        default:
                            break
                        }
                    }
                }) {
                    Text(buttonTitle)
                        .foregroundColor(buttonEnabled ? Constants.Colors.green : .secondary)
                        .font(Font.custom(Constants.Fonts.semibold, size: 18))
                        .cornerRadius(15)
                }
                .disabled(!buttonEnabled)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 32))
            }
            .frame(height: 50)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onboardingDone: .constant(false))
    }
}
