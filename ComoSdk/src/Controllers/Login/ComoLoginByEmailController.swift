import UIKit
import RevoUIComponents

class ComoLoginByEmailController : UIViewController, OTPViewDelegate {
    
    @IBOutlet var loginOtpView: UIView!
    @IBOutlet var searchButton: AsyncButton!
    @IBOutlet var inputField: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    weak var delegate:ComoLoginDelegate!
    
    override func viewDidLoad() {
        searchButton.round(4)
        errorLabel.text = ""
        loginOtpView.isHidden = true
    }
    
    @IBAction func onSearchPressed(_ sender: Any) {
                
        errorLabel.text = ""
        
        guard (inputField.text?.count ?? 0) > 0 else {
            return inputField.shake()
        }
        
        guard inputField.text!.contains("@") else {
            return inputField.shake()
        }
        
        sendAuthCode()
    }
    
    func sendAuthCode(){
        Task {
            do {
                searchButton.animateProgress()
                try await Como.shared.sendIdentificationCode(customer:
                    Como.Customer(email: inputField.text!.lowercased().trim())
                )
                await MainActor.run {
                    searchButton.animateSuccess()
                    onCodeSent()
                }
            } catch {
                await MainActor.run {
                    searchButton.animateFailed()
                    onError(error)
                }
            }
        }
    }
    
    private func onCodeSent(){
        loginOtpView.isHidden = false
        searchButton.isHidden = true
        inputField.isHidden = true
        loginOtpView.subviews.first {
            $0 is OTPView
        }?.becomeFirstResponder()
    }
    
    private func resetView(){
        loginOtpView.isHidden = true
        searchButton.isHidden = false
        inputField.isHidden = false
        searchButton.reset()
    }
    
    func otp(codeEntered code: String) {
        getMemberDetails(code)
    }
    
    func getMemberDetails(_ code:String){
        let customer = Como.Customer(appClientId: code)
        
        searchButton.animateProgress()
        Task {
            do {
                let details = try await Como.shared.getMemberDetails(
                    customer: customer, 
                    purchase: Como.shared.currentSale!.purchase
                )
                Como.shared.currentSale?.customer = details.membership.customer
                await MainActor.run {
                    resetView()
                    delegate?.como(onLoggedIn: details)
                }
            } catch {
                await MainActor.run {
                    loginOtpView.shake()
                    searchButton.animateFailed()
                    onError(error, asOtp:true)
                }
            }
        }
    }
    
    private func onError(_ error:Error, asOtp:Bool = false){
        if "\(error)".contains("4001012") && !asOtp { //Customer not found
            return askToRegister()
        }
        errorLabel.text = Como.trans("como_\(error)")
    }
    
    private func askToRegister(){
        Task {
            if case .ok = await Alert(Como.trans("como_wantToRegister"), message:Como.trans("como_wantToRegisterDesc"), cancelText: Como.trans("como_no")).show() {
                do {
                    searchButton.animateProgress()
                    let customer = Como.Customer(email: inputField.text!.lowercased().trim())
                                  try await Como.shared.quickRegister(customer: customer)
                    let details = try await Como.shared.getMemberDetails(
                        customer: customer,
                        purchase: Como.shared.currentSale!.purchase
                    )
                    searchButton.animateSuccess()
                    delegate?.como(onLoggedIn: details)
                } catch {
                    searchButton.animateFailed()
                    onError(error)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ComoControllerLoginOTPController)?.delegate = self
    }
}
