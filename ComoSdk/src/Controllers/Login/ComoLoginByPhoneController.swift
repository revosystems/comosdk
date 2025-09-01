import UIKit
import RevoUIComponents
import RevoFoundation
import PhoneNumberKit

class ComoLoginByPhoneController : UIViewController, PhoneCountryControllerDelegate, UITextFieldDelegate, OTPViewDelegate {
    
    enum PhoneValidationError: Error {
        case InvalidPhoneNumber
    }

    @IBOutlet var loginOtpView: UIView!
    @IBOutlet var searchButton: AsyncButton!
    @IBOutlet var inputField: PhoneNumberTextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    weak var delegate:ComoLoginDelegate!
    
    var phoneCountry = PhoneCountryEnum.spain.country
    
    override func viewDidLoad() {
        searchButton.round(4)
        searchButton.isEnabled = false
        errorLabel.text = ""
        loginOtpView.isHidden = true
        inputField.delegate = self
        inputField.withFlag = true
        inputField.withDefaultPickerUI = true
        phoneCountrySelector(countrySelected: phoneCountry)
    }
    
    @IBAction func onSearchPressed(_ sender:Any){
        
        errorLabel.text = ""
        
        guard inputField.isValidNumber else {
            searchButton.isEnabled = false
            return inputField.shake()
        }
                
        sendAuthCode()
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        searchButton.isEnabled = inputField.isValidNumber
    }
    
    func phoneCountrySelector(countrySelected: PhoneCountry) {
        phoneCountry = countrySelected
    }
    
    var phone:String {
        (phoneCountry.prefix + inputField.text!).replace("+", "").trim()
    }
    
    func sendAuthCode(){
        Task {
            do {
                searchButton.animateProgress()
                guard let phone = inputField.phoneNumber else { throw PhoneValidationError.InvalidPhoneNumber }
                let completePhone = "\(phone.countryCode)\(phone.nationalNumber)".replace("+", "").replace(" ", "").trim()
                try await Como.shared.sendIdentificationCode(
                    customer: Como.Customer(phoneNumber:completePhone)
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
        loginOtpView.subviews.first?.subviews.first {
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
        Task {
            do {
                let customer = Como.Customer(appClientId: code)
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
                    onError(error, asOtp: true)
                }
            }
        }
    }
    
    private func onError(_ error:Error, asOtp:Bool = false){
        if let error = error as? PhoneValidationError {
            return errorLabel.text = "Número de teléfono inválido"
        }
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
                    let customer = Como.Customer(phoneNumber: phone)
                                  try await Como.shared.quickRegister(customer: customer)
                    let details = try await Como.shared.getMemberDetails(customer: customer, purchase: Como.shared.currentSale!.purchase)
                    
                    Como.shared.currentSale?.customer = details.membership.customer
                    
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
