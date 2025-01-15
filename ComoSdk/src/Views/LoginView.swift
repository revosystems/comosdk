import SwiftUI
import DejavuSwift

public struct LoginView: View {
    
    @State private var email:String = ""
    @State private var phoneNumber:String = ""
    @State private var qrcode:String = ""
    
    @State private var loading = false
    @State private var tab = 0
    @State private var errorMessage:String = ""
    @State private var membership:Como.Membership? = nil
            
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
                        TextField("Phone number", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if loading {
                            ProgressView()
                        }
                        
                        ButtonPrimary("Login") {
                            fetchCustomerDetails(customer: Como.Customer(phoneNumber: phoneNumber))
                        }
                        
                        Text(errorMessage)
                            .opacity(0.5)
                    }
                    else if tab == 1 {
                        TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if loading {
                            ProgressView()
                        }
                        
                        ButtonPrimary("Login") {
                            fetchCustomerDetails(customer: Como.Customer(email: email))
                        }
                        
                        Text(errorMessage)
                            .opacity(0.5)
                    } else if tab == 2 {
                        TextField("QRCode", text: $qrcode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if loading {
                            ProgressView()
                        }
                        
                        ButtonPrimary("Login") {
                            fetchCustomerDetails(customer: Como.Customer(appClientId: qrcode))
                        }
                        
                        Text(errorMessage)
                            .opacity(0.5)
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
            .background(Dejavu.background)
            .task {
                //fetchCustomerDetails(customer: Como.Customer(commonExtId: "89f6c22c-a7fc-41b2-b38e-6b763036e2e2"))
            }
        }
    }
    
    private func fetchCustomerDetails(customer:Como.Customer){
        Task {
            do {
                loading = true
                membership = try await Como.shared.getMemberDetails(
                    customer: customer,
                    purchase:nil
                ).membership
                loading = false
            }catch{
                loading = false
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
    Como.shared.setup(
        key: "Zg8Wpd76",
        branchId: "1",
        posId: "1",
        source: "1",
        sourceVersion: "1",
        url: "https://pos-api.fidelizacion.app/api/v4/"
    )
    
    return LoginView()
}
