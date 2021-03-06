
import SwiftUI

// MARK: ID page for onboarding
struct OnboardingIdView: View {
    @Binding var idRetrieved: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var notificationTitle = "Your ID: "
    @State private var showNotification = false
    @State private var gettingId = false
    private let haptics = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        VStack(alignment: .leading) {
            Text("Your ID")
                .foregroundColor(.primary)
                .font(Font.custom(Constants.Fonts.medium, size: 36))
            Text("You need to register an ID before you can start hiking. We use this to keep track of your hikes without knowing who you are.")
                .foregroundColor(.secondary)
                .font(Font.custom(Constants.Fonts.regular, size: 18))
                .padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
            
            HStack {
                HikerNetButton(title: "Get ID", disabled: idRetrieved) {
                    getId()
                }
                if gettingId {
                    LottieView(name: "loading", play: $gettingId, loop: false)
                        .frame(width: 75, height: 75)
                }
                LottieView(name: "checkmark", play: $idRetrieved, loop: false)
                    .frame(width: 75, height: 75)
                    .opacity(idRetrieved ? 1.0 : 0)
                
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
            }
            
            Spacer()
            VStack() {
                Text(notificationTitle)
                    .padding()
                    .frame(maxHeight: 50)
                    .background(Color(UIColor.systemGray6))
                    .multilineTextAlignment(.center)
                    .cornerRadius(25)
                    .animation(.easeInOut)
                    .transition(.opacity)
                    .opacity(showNotification ? 1 : 0)
            }.frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 24, leading: 36, bottom: 0, trailing: 36))

    }
    
    private func getId() {
        haptics.impactOccurred()
        gettingId = true
        ApiManager.getId { res in
            switch res {
            case .success(let id):
                notificationTitle = "Your ID: \(id)"
                withAnimation { showNotification = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation { showNotification = false }
                }
                UserDefaultsManager.setId(id: id)
                UserDefaultsManager.setOnboardingDone(done: true)
                idRetrieved = true
            case .failure(let err):
                switch err {
                case ApiError.RequestError:
                    alertMessage = "There was problem with the request. Please try again later."
                case ApiError.ServerError:
                    alertMessage = "There was problem with our servers. Please try again later."
                case ApiError.ConnectionError:
                    alertMessage = "There was a problem with the internet connection. Please try again later."
                }
                showAlert = true
            }
            gettingId = false
        }
    }
}

struct OnboardingId_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingIdView(idRetrieved: .constant(false))
    }
}
