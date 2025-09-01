import UIKit
import RevoUIComponents
import RevoFoundation
import PhoneNumberKit

class ComoRegisterByPhoneController : UIViewController, OTPViewDelegate {
    
    enum PhoneValidationError: Error {
        case InvalidPhoneNumber
    }
        
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var button: AsyncButton!
    @IBOutlet var textField: PhoneNumberTextField!
    
    weak var delegate:ComoRegisterDelegate?
     
    override func viewDidLoad() {
        errorLabel.text = ""
        button.round(4)
        button.isEnabled = false
        textField.withFlag = true
        textField.withDefaultPickerUI = true
    }
    
    var phone:String? {
        guard let validInputPhone = textField.phoneNumber else { return nil }
        return "\(validInputPhone.countryCode)\(validInputPhone.nationalNumber)".replace("+", "").replace(" ", "").trim()
    }
    
    
    @IBAction func onButtonPressed(_ sender: Any) {
        errorLabel.text = ""
        
        guard textField.isValidNumber else {
            button.isEnabled = false
            return textField.shake()
        }
        
        Task {
            do {
                button.animateProgress()
                guard let phone else { throw PhoneValidationError.InvalidPhoneNumber }
                let customer = Como.Customer(phoneNumber: phone)
                let _        = try await Como.shared.quickRegister(customer: customer)
                let details  = try await Como.shared.getMemberDetails(
                    customer: customer,
                    purchase: Como.shared.currentSale!.purchase
                )
                await MainActor.run {
                    button.animateSuccess()
                    delegate?.como(registered: details)
                }
            } catch {
                await MainActor.run {
                    textField.shake()
                    button.animateFailed()
                    errorLabel.text = Como.trans("como_\(error)")
                }
            }
        }
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        button.isEnabled = textField.isValidNumber
    }
    
    func otp(codeEntered code: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? ComoControllerLoginOTPController)?.delegate = self
    }
}
