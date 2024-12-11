import SwiftUI
import DejavuSwift

public struct LoginView: View {
    
    @State private var email:String = ""
    @State private var loading = false
    @State private var tab = 0
    @State private var errorMessage:String = ""
    @State private var membership:Como.Membership? = nil
    
    public init(){
        //89f6c22c-a7fc-41b2-b38e-6b763036e2e2
    }
    
    public var body: some View {
        if #available(iOS 15.0, *) {
            VStack(spacing: 12) {
                
                if let membership {
                    BenefitsView(membership: membership)
                }
                else{
                    Picker("LoginMethod", selection: $tab) {
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
                        .cornerRadius(8)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 8)
                        .background(Dejavu.brand)
                        .foregroundColor(.white)
                        .frame(maxWidth:.infinity)
                        
                        Text(errorMessage)
                            .opacity(0.5)
                        
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
            }
            .padding()
            .task {
                fetchCustomerDetails()
            }
        }
    }
    
    private func fetchCustomerDetails(){
        Como.shared.setup(
            key: "Zg8Wpd76",
            branchId: "1",
            posId: "1",
            source: "1",
            sourceVersion: "1",
            url: "https://pos-api.fidelizacion.app/api/v4/"
        )
        
        Task {
            do {
                membership = try await Como.shared.getMemberDetails(
                    customer: Como.Customer(commonExtId: "89f6c22c-a7fc-41b2-b38e-6b763036e2e2"),
                    purchase:nil
                ).membership
            }catch{
                print(error)
                errorMessage = "\(error)"
            }
        }
    }
    
    private func loginWithEmail(){
        Task {
            Como.shared.setup(
                key: "Zg8Wpd76",
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
                if "\(error)".contains("4001012") {
                    askToRegister()
                }
                print(error)
                errorMessage = "\(error)"
            }
        }
    }
    
    private func askToRegister(){
        Task {
            do {
                let details = try await Como.shared.quickRegister(customer: Como.Customer(email: email))
                print(details)
            }catch {
                print(error)
                errorMessage = "\(error)"
            }
        }
        
    }
    
    private func register(){
        
    }
}



#Preview {
    LoginView()
}
