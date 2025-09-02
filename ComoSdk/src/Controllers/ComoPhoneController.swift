import UIKit
import RevoUIComponents
import RevoFoundation
import PhoneNumberKit

class ComoPhoneController : UIViewController {
    
    enum PhoneValidationError: Error {
        case InvalidPhoneNumber
    }
    
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var button: AsyncButton!
    @IBOutlet var textField: PhoneNumberTextField!
    
    var buttonTitleKey: String { "search" }
    
    override func viewDidLoad() {
        clearError()
        
        button.round(4)
        button.isEnabled = false
        button.setTitle(Como.trans(buttonTitleKey), for: .normal)
        
        textField.withFlag = true
        textField.withDefaultPickerUI = true
        
        setupController()
    }
    
    // Overridable
    func setupController() { }
    
    var phone: String? {
        guard let validInputPhone = textField.phoneNumber else { return nil }
        return "\(validInputPhone.countryCode)\(validInputPhone.nationalNumber)".replace("+", "").replace(" ", "").trim()
    }
    
    @IBAction func onButtonPressed(_ sender: Any) {
        clearError()
        
        guard textField.isValidNumber else {
            button.isEnabled = false
            return textField.shake()
        }
        
        performAction()
    }
    
    // Overridable
    func performAction() { }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        button.isEnabled = textField.isValidNumber
    }
    
    func showError(_ error: Error) {
        if let error = error as? PhoneValidationError {
            errorLabel.text = "Número de teléfono inválido"
            return
        }
        
        showError(Como.trans("como_\(error)"))
    }
    
    func showError(_ message: String) {
        errorLabel.text = message
    }
    
    func clearError() {
        errorLabel.text = ""
    }
}
