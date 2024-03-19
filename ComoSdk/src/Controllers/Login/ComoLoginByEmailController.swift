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
                    Como.Customer(email: inputField.text!.lowercased())
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
    }
    
    func otp(codeEntered code: String) {
        getMemberDetails(code)
    }
    
    func getMemberDetails(_ code:String){
        let customer = Como.Customer(email: inputField.text!.lowercased())
        
        searchButton.animateProgress()
        Task {
            do {
                let details = try await Como.shared.getMemberDetails(
                    customer: customer, 
                    purchase: Como.shared.currentSale!.purchase,
                    code: code
                )
                Como.shared.currentSale?.customer = details.membership.customer
                await MainActor.run {
                    searchButton.animateSuccess()
                    delegate?.como(onLoggedIn: details)
                }
            } catch {
                await MainActor.run {
                    searchButton.animateFailed()
                    onError(error)
                }
            }
        }
    }
    
    private func onError(_ error:Error){
        errorLabel.text = Como.trans("como_\(error)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ComoControllerLoginOTPController)?.delegate = self
    }
}
