import SwiftUI
import DejavuSwift

public struct LoginView: View {
    
    @State private var email:String = ""
    @State private var loading = false
    @State private var tab = 0
    
    public init(){
        
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            
            Picker("What is your favorite color?", selection: $tab) {
                Text("Teléfono").tag(0)
                Text("Email").tag(1)
                Text("QR").tag(2)
            }
            .pickerStyle(.segmented)
            
            Spacer().frame(height:20)
            
            if tab == 0 {
                TextField(
                    "User name (email address)",
                    text: $email
                )
                
                Button("Login") {
                    loginWithEmail()
                }                
                .padding(.horizontal, 60)
                .padding(.vertical, 8)
                .background(Dejavu.brand)
                .foregroundColor(.white)
                .frame(maxWidth:.infinity)
                .cornerRadius(8)
            }
            else if tab == 1 {
                Text("Phone")
            } else if tab == 2 {
                Text("QRCode")
            }
            
            Spacer()
            Divider()
            Text("¿Tu cliente no tiene cuenta?")
                .opacity(0.6)
            Button("Register") {
                register()
            }
        }
        .padding()
    }
    
    private func loginWithEmail(){
        Task {
            Como.shared.setup(
                key: "xm2EHOel",
                branchId: "1",
                posId: "1",
                source: "1",
                sourceVersion: "1",
                url: "https://pos-api.fidelizacion.app/api/v4/"
            )
            
            do {
                let details = try await Como.shared.getMemberDetails(
                    customer: Como.Customer(email: email),
                    purchase: nil
                )
                print(details)
            } catch {
                print(error)
            }
        }
    }
    
    private func register(){
        
    }
}



#Preview {
    LoginView()
}
